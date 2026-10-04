package com.carecar.tag;

import com.carecar.util.FormatUtil;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Custom Tag: <cc:formatDate value="..." pattern="dd/MM/yyyy|dd/MM/yyyy HH:mm" />
 * Định dạng ngày tháng giờ chuẩn Việt Nam
 */
public class FormatDateTag extends SimpleTagSupport {

    private Object value;
    private String pattern = "dd/MM/yyyy HH:mm";

    public void setValue(Object value) {
        this.value = value;
    }

    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        if (value == null) {
            out.print("—");
            return;
        }

        try {
            Date dateObj = null;
            if (value instanceof Date) {
                dateObj = (Date) value;
            } else if (value instanceof java.sql.Timestamp) {
                dateObj = new Date(((java.sql.Timestamp) value).getTime());
            } else if (value instanceof java.sql.Date) {
                dateObj = new Date(((java.sql.Date) value).getTime());
            }

            if (dateObj != null) {
                SimpleDateFormat sdf = new SimpleDateFormat(pattern);
                out.print(sdf.format(dateObj));
            } else {
                out.print(value.toString());
            }
        } catch (Exception e) {
            out.print(value.toString());
        }
    }
}
