import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.Statement;
import vn.iotstar.connection.DBConnection_24133007;

/** Applies only the additive shopping migration, never the destructive database.sql. */
public class ShoppingDatabaseSetup {
    public static void main(String[] args) throws Exception {
        try (Connection c = DBConnection_24133007.getConnection()) {
            if (c == null) throw new IllegalStateException("Database connection unavailable");
            try (Statement statement = c.createStatement()) {
                for (String file : new String[]{"database-shopping.sql", "database-courses.sql"}) {
                    String sql = Files.readString(Path.of(file));
                    for (String batch : sql.split("(?im)^GO\\s*$")) {
                        if (!batch.isBlank()) statement.execute(batch);
                    }
                }
            }
            System.out.println("Shopping migration completed.");
        }
    }
}
