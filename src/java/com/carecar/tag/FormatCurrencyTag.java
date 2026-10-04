package com.carecar.tag;

import com.carecar.util.FormatUtil;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Custom Tag: <cc:formatCurrency value="..." />
 * Định dạng số tiền VNĐ chuyên nghiệp cho giao diện JSP
 */
public class FormatCurrencyTag extends SimpleTagSupport {

    private Object value;

    public void setValue(Object value) {
        this.value = value;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        if (value == null) {
            out.print("0 ₫");
            return;
        }

        try {
            if (value instanceof BigDecimal) {
                out.print(FormatUtil.formatCurrency((BigDecimal) value));
            } else if (value instanceof Number) {
                out.print(FormatUtil.formatCurrency(((Number) value).doubleValue()));
            } else {
                double val = Double.parseDouble(value.toString());
                out.print(FormatUtil.formatCurrency(val));
            }
        } catch (Exception e) {
            out.print(value.toString() + " ₫");
        }
    }
}
