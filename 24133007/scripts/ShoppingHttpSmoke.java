import java.net.*;
import java.net.http.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;
import java.util.regex.*;
import vn.iotstar.connection.DBConnection_24133007;
import vn.iotstar.dao.ShoppingDao_24133007;
import vn.iotstar.entity.OrderStatus_24133007;

/** HTTP test against a deployed Tomcat 11; creates and removes isolated SQL fixtures. */
public class ShoppingHttpSmoke {
    private static String base;
    private static final HttpClient client = HttpClient.newBuilder()
        .cookieHandler(new CookieManager(null, CookiePolicy.ACCEPT_ALL))
        .followRedirects(HttpClient.Redirect.ALWAYS).build();
    private static HttpResponse<String> get(String path) throws Exception {
        return client.send(HttpRequest.newBuilder(URI.create(base + path)).GET().build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }
    private static HttpResponse<String> post(String path, Map<String,String> fields) throws Exception {
        List<String> encoded = new ArrayList<>();
        for (var entry : fields.entrySet()) encoded.add(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8) + "=" + URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8));
        return client.send(HttpRequest.newBuilder(URI.create(base + path))
            .header("Content-Type", "application/x-www-form-urlencoded")
            .POST(HttpRequest.BodyPublishers.ofString(String.join("&", encoded))).build(), HttpResponse.BodyHandlers.ofString(StandardCharsets.UTF_8));
    }
    private static String token(String html, String name) {
        Matcher match = Pattern.compile("name=\"" + name + "\" value=\"([^\"]+)\"").matcher(html);
        if (!match.find()) throw new AssertionError("Missing form token: " + name);
        return match.group(1);
    }
    private static void check(boolean condition, String message) {
        if (!condition) throw new AssertionError(message);
    }
    private static void sql(Connection c, String query, Object... values) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(query)) {
            for (int i = 0; i < values.length; i++) ps.setObject(i + 1, values[i]);
            ps.executeUpdate();
        }
    }
    public static void main(String[] args) throws Exception {
        base = args.length == 0 ? "http://localhost:18080/24133007" : args[0];
        String username = "http_test_" + UUID.randomUUID().toString().substring(0, 20);
        String privateId = username + "_private", publicId = username + "_public";
        String privateUrl="https://example.com/private-"+username+".mp4", publicUrl="https://example.com/public-"+username+".mp4";
        int productId = 0;
        try (Connection c = DBConnection_24133007.getConnection()) {
            if (c == null) throw new IllegalStateException("SQL Server connection required");
            try {
                sql(c, "INSERT INTO Users(Username,Password,Fullname,Phone,Active) VALUES(?,'test-only',N'HTTP test','0912345678',1)", username);
                try (PreparedStatement ps = c.prepareStatement("INSERT INTO Products(Name,Price,Stock,Active) VALUES(N'HTTP fixture',35000,5,1)", Statement.RETURN_GENERATED_KEYS)) {
                    ps.executeUpdate(); try (ResultSet rs = ps.getGeneratedKeys()) { rs.next(); productId = rs.getInt(1); }
                }
                sql(c,"INSERT INTO Videos(VideoId,Title,VideoUrl,Active,CourseId,IsPrivate) VALUES(?,N'Private fixture',?,1,?,1)",privateId,privateUrl,productId);
                sql(c,"INSERT INTO Videos(VideoId,Title,VideoUrl,Active,CourseId,IsPrivate) VALUES(?,N'Public fixture',?,1,?,0)",publicId,publicUrl,productId);
                check(!get("/video/detail?id="+privateId).body().contains(privateUrl),"Guest must not receive private URL");
                check(get("/video/detail?id="+publicId).body().contains(publicUrl),"Guest can watch public video");
                var products = get("/products");
                check(products.statusCode() == 200 && products.body().contains("HTTP fixture"), "Product JSP must render");
                check(products.body().contains("Private fixture") && products.body().contains("Public fixture"),
                    "Course catalog must render lesson properties, including public/private labels");
                String csrf = token(products.body(), "csrf");
                check(post("/cart", Map.of("action","add","productId",""+productId,"quantity","1")).statusCode() == 403, "CSRF protection");
                var cart = post("/cart", Map.of("csrf",csrf,"action","add","productId",""+productId,"quantity","2"));
                check(cart.statusCode() == 200 && cart.body().contains("70.000"), "Add and money display");
                cart = post("/cart", Map.of("csrf",csrf,"action","add","productId",""+productId,"quantity","1"));
                check(cart.body().contains("105.000"), "Merge same product");
                cart = post("/cart", Map.of("csrf",csrf,"action","update","productId",""+productId,"quantity","0"));
                check(cart.body().contains("Số lượng phải từ 1") && cart.body().contains("105.000"), "Invalid quantity rejected without changing cart");
                cart = post("/cart", Map.of("csrf",csrf,"action","update","productId",""+productId,"quantity","1"));
                check(cart.body().contains("35.000"), "Update quantity");
                check(get("/checkout").uri().getPath().endsWith("/login"), "Guest checkout requires login");
                var checkout = post("/login", Map.of("username", username,"password","test-only"));
                check(checkout.statusCode() == 200 && checkout.uri().getPath().endsWith("/checkout"), "Login resumes checkout");
                String checkoutToken = token(checkout.body(), "checkoutToken");
                Map<String,String> orderForm = Map.of("csrf",csrf,"checkoutToken",checkoutToken,"paymentMethod","COD",
                    "recipient","<script>test</script>","phone","0912345678","address","Test address","note","HTTP smoke");
                var history = post("/checkout", orderForm);
                check(history.statusCode() == 200 && history.uri().getPath().endsWith("/orders"), "COD redirects to history");
                check(history.body().contains("Đơn hàng mới") && history.body().contains("&lt;script&gt;test&lt;/script&gt;"), "History status and escaped delivery data");
                ShoppingDao_24133007 dao = new ShoppingDao_24133007();
                long id = dao.history(username, null).get(0).id();
                String activationCode;
                try(PreparedStatement ps=c.prepareStatement("SELECT Code FROM ActivationCodes WHERE OrderId=?")) {
                    ps.setLong(1,id);try(ResultSet rs=ps.executeQuery()){check(rs.next(),"Checkout generates activation code");activationCode=rs.getString(1);check(!rs.next(),"One code per seat");}
                }
                check(!history.body().contains(activationCode),"Code is physically shipped, not displayed to buyer");
                check(get("/admin/course-codes").statusCode()==403,"Buyer cannot access shipment codes");
                check(!get("/video/detail?id="+privateId).body().contains(privateUrl),"Purchase alone does not unlock private video");
                check(post("/activate",Map.of("csrf",csrf,"code",activationCode)).body().contains("Mã chỉ kích hoạt được"),"Undelivered code rejected");
                check(dao.find(productId).stock() == 4, "Stock reduced once");
                check(get("/cart").body().contains("Giỏ hàng đang trống"), "Cart cleared after order");
                check(post("/checkout", orderForm).statusCode() == 200 && dao.history(username,null).size() == 1, "Duplicate submit does not create another order");
                for (var status : OrderStatus_24133007.values()) {
                    sql(c, "UPDATE Orders SET Status=? WHERE OrderId=?", status.name(), id);
                    history = get("/orders?status=" + status.name());
                    check(history.statusCode() == 200 && history.body().contains("Đơn #" + id) && history.body().contains(status.getLabel()), "Filter " + status.name());
                    if (status != OrderStatus_24133007.NEW) check(!get("/orders?status=NEW").body().contains("Đơn #" + id), "Old filter excludes moved order");
                }
                check(get("/orders?status=INVALID").statusCode() == 400, "Invalid filter rejected");
                sql(c,"UPDATE Orders SET Status='DELIVERED' WHERE OrderId=?",id);
                check(post("/activate",Map.of("code",activationCode)).statusCode()==403,"Activation requires CSRF");
                var activated=post("/activate",Map.of("csrf",csrf,"code",activationCode.toLowerCase(Locale.ROOT)));
                check(activated.statusCode()==200 && activated.uri().getPath().endsWith("/my-courses") && activated.body().contains("Private fixture"),"Activation opens course library");
                check(get("/video/detail?id="+privateId).body().contains(privateUrl),"Activated account can watch private video");
                check(post("/activate",Map.of("csrf",csrf,"code",activationCode)).body().contains("Mã kích hoạt đã được sử dụng"),"Activation code single use");
                sql(c,"UPDATE Orders SET Status='RETURNED' WHERE OrderId=?",id);
                check(!get("/video/detail?id="+privateId).body().contains(privateUrl),"Returned order revokes private access");
                check(get("/WEB-INF/views/shopping/orders.jsp").statusCode() == 404, "Views protected");
                cart = post("/cart", Map.of("csrf",csrf,"action","add","productId",""+productId,"quantity","1"));
                cart = post("/cart", Map.of("csrf",csrf,"action","remove","productId",""+productId));
                check(cart.body().contains("Giỏ hàng đang trống"), "Remove product");
                post("/cart", Map.of("csrf",csrf,"action","add","productId",""+productId,"quantity","1"));
                cart = post("/cart", Map.of("csrf",csrf,"action","clear"));
                check(cart.body().contains("Giỏ hàng đang trống"), "Clear cart");
                sql(c,"UPDATE Users SET Admin=1 WHERE Username=?",username);
                check(post("/login",Map.of("username",username,"password","test-only")).statusCode()==200,"Admin fixture login");
                var shipment=get("/admin/course-codes");
                check(shipment.statusCode()==200 && shipment.body().contains(activationCode) && shipment.body().contains("Test address"),"Admin can print code and shipping address");
                check(shipment.headers().firstValue("Cache-Control").orElse("").contains("no-store"),"Shipment code page cannot be cached");
                var videoForm=get("/admin/videos/edit?id="+privateId);
                check(videoForm.statusCode()==200 && videoForm.body().contains("privateVideo") && videoForm.body().contains("HTTP fixture"),"Admin course and visibility form");
                check(post("/admin/videos/edit",Map.of("videoId",privateId)).statusCode()==403,"Admin video edit needs CSRF");
                var edited=post("/admin/videos/edit",Map.of("videoCsrf",token(videoForm.body(),"videoCsrf"),"videoId",privateId,"title","Public after edit","videoUrl",privateUrl,"active","true","categoryId","1","courseId",""+productId,"privateVideo","false"));
                check(edited.statusCode()==200,"Admin can change private to public");
                get("/logout");
                check(get("/video/detail?id="+privateId).body().contains(privateUrl),"Public setting applied for guests");
                System.out.println("HTTP smoke passed: cart/COD/history, public/private videos, hidden private URLs, physically shipped codes, delivery gate, activation, single use, returned-order revocation.");
            } finally {
                sql(c, "DELETE FROM ActivationCodes WHERE OrderId IN (SELECT OrderId FROM Orders WHERE Username=?)", username);
                sql(c, "DELETE FROM OrderItems WHERE OrderId IN (SELECT OrderId FROM Orders WHERE Username=?)", username);
                sql(c, "DELETE FROM Orders WHERE Username=?", username);
                sql(c, "DELETE FROM Videos WHERE VideoId IN (?,?)",privateId,publicId);
                if (productId != 0) sql(c, "DELETE FROM Products WHERE ProductId=?", productId);
                sql(c, "DELETE FROM Users WHERE Username=?", username);
            }
        }
    }
}
