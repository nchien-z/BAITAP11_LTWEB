package vn.iotstar.config;

import java.io.IOException;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.sitemesh.webapp.SiteMeshFilter;
import org.sitemesh.webapp.WebAppContext;
import org.sitemesh.webapp.contentfilter.ResponseMetaData;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpServletRequestWrapper;

@WebFilter(filterName = "sitemeshFilter", urlPatterns = "/*")
public class AppSiteMeshFilter_24133007 extends ConfigurableSiteMeshFilter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest wrapped = new HttpServletRequestWrapper((HttpServletRequest) request) {
            @Override
            public RequestDispatcher getRequestDispatcher(String path) {
                RequestDispatcher delegate = super.getRequestDispatcher(path);
                if (delegate == null || path == null || !path.endsWith(".jsp")) return delegate;
                return new RequestDispatcher() {
                    @Override
                    public void forward(ServletRequest req, ServletResponse resp) throws ServletException, IOException {
                        // Giữ response chưa commit cho bước ghép layout sau khi view được render.
                        resp.setContentType("text/html; charset=UTF-8");
                        delegate.include(req, resp);
                    }
                    @Override
                    public void include(ServletRequest req, ServletResponse resp) throws ServletException, IOException {
                        delegate.include(req, resp);
                    }
                };
            }
        };
        super.doFilter(wrapped, response, chain);
    }

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.setDecoratorPrefix("");
        builder.addDecoratorPath("/admin/*", "/WEB-INF/decorators/admin.jsp");
        builder.addDecoratorPath("/admin", "/WEB-INF/decorators/admin.jsp");
        builder.addDecoratorPath("/*", "/WEB-INF/decorators/web.jsp");

        // Loại trừ tài nguyên tĩnh
        builder.addExcludedPath("/static/*");
        builder.addExcludedPath("/assets/*");
    }

    @Override
    protected boolean reloadRequired() {
        // Cấu hình khai báo bằng Java, không có file XML để theo dõi thay đổi.
        return false;
    }

    @Override
    protected Filter setup() {
        SiteMeshFilterBuilder builder = new SiteMeshFilterBuilder();
        applyCustomConfiguration(builder);
        return new SiteMeshFilter(builder.getSelector(), builder.getContentProcessor(),
                builder.getDecoratorSelector(), builder.isIncludeErrorPages()) {
            @Override
            protected WebAppContext createContext(String contentType, HttpServletRequest request,
                    HttpServletResponse response, ResponseMetaData metaData) {
                return new WebAppContext(contentType, request, response, getFilterConfig().getServletContext(),
                        getContentProcessor(), metaData, builder.isIncludeErrorPages()) {
                    @Override
                    protected void dispatch(HttpServletRequest req, HttpServletResponse resp, String path)
                            throws ServletException, IOException {
                        // Servlet forward đã hoàn tất; include decorator vào buffer của SiteMesh.
                        getServletContext().getRequestDispatcher(path).include(req, resp);
                    }
                };
            }
        };
    }
}
