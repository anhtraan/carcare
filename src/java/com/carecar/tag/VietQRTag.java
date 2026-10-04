package com.carecar.tag;

import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * Custom Tag: <cc:vietQR bank="Vietcombank|MBBank|..." account="0901234567" amount="1500000" orderCode="CC-2026-0001" />
 * Tạo URL mã QR thanh toán nhanh VietQR chuẩn Ngân Hàng Nhà Nước
 */
public class VietQRTag extends SimpleTagSupport {

    private String bank = "vietcombank";
    private String account = "0011004567890";
    private String accountName = "GARAGE CARECAR AUTO";
    private Object amount;
    private String orderCode = "CARECAR";
    private String template = "compact2"; // compact2, qr_only, compact

    public void setBank(String bank) {
        this.bank = bank;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public void setAmount(Object amount) {
        this.amount = amount;
    }

    public void setOrderCode(String orderCode) {
        this.orderCode = orderCode;
    }

    public void setTemplate(String template) {
        this.template = template;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        long amt = 0;
        if (amount != null) {
            try {
                if (amount instanceof Number) {
                    amt = ((Number) amount).longValue();
                } else {
                    amt = (long) Double.parseDouble(amount.toString());
                }
            } catch (Exception ignored) {
            }
        }

        String memo = URLEncoder.encode("THANH TOAN " + orderCode, StandardCharsets.UTF_8);
        String name = URLEncoder.encode(accountName, StandardCharsets.UTF_8);
        // VietQR API: https://img.vietqr.io/image/{bankId}-{accountNo}-{template}.png?amount={amount}&addInfo={memo}&accountName={name}
        String qrUrl = String.format("https://img.vietqr.io/image/%s-%s-%s.png?amount=%d&addInfo=%s&accountName=%s",
                bank.toLowerCase(), account, template, amt, memo, name);

        out.print(qrUrl);
    }
}
