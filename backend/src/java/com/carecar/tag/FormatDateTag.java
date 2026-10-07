package com.carecar.tag;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.lang.reflect.Method;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;

/**
 * Custom Tag: <cc:formatDate value="..." pattern="dd/MM/yyyy|dd/MM/yyyy HH:mm" />
 * Định dạng ngày tháng giờ chuẩn Việt Nam bằng java.time API
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
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern(pattern).withZone(ZoneId.systemDefault());

            if (value instanceof TemporalAccessor temporal) {
                out.print(formatter.format(temporal));
                return;
            }

            if (value instanceof Instant instant) {
                out.print(formatter.format(instant));
                return;
            }

            Method getTimeMethod = value.getClass().getMethod("getTime");
            Object timeObj = getTimeMethod.invoke(value);
            if (timeObj instanceof Long timeMillis) {
                out.print(formatter.format(Instant.ofEpochMilli(timeMillis)));
                return;
            }

            out.print(value.toString());
        } catch (Exception e) {
            out.print(value.toString());
        }
    }
}
