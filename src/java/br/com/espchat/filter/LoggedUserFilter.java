package br.com.espchat.filter;

import br.com.espchat.entities.User;
import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import br.com.espchat.util.Constants;

/**
 *
 * @author edson
 */
public class LoggedUserFilter implements Filter {

    public void init(FilterConfig fConfig) throws ServletException {

    }

    public void destroy() {
    }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession();

        HttpServletResponse res = (HttpServletResponse) response;

        String url = req.getRequestURL().toString();
        if (needsRedirectToLoginPage(session, url)) {
            res.sendRedirect(Constants.LOGIN_PAGE);
            return;
        }

        chain.doFilter(request, response);
    }

    public boolean needsRedirectToLoginPage(HttpSession session, String url) {
        User sessionUser = (User) session.getAttribute(Constants.LOGGED_USER);
        return (sessionUser == null)
                && (!url.contains(Constants.LOGIN_PAGE)
                && !url.contains(Constants.VALIDATE_LOGIN)
                && !url.contains(Constants.REGISTER_USER)
                && !url.contains(Constants.VALIDATE_LOGIN_SOCIAL)
                && url.contains(Constants.JSP_PAGES_EXTENSION));
    }

}
