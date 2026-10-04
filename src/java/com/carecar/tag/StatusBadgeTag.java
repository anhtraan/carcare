package com.carecar.tag;

import com.carecar.util.FormatUtil;
import jakarta.servlet.jsp.JspException;
import jakarta.servlet.jsp.JspWriter;
import jakarta.servlet.jsp.tagext.SimpleTagSupport;
import java.io.IOException;

/**
 * Custom Tag: <cc:statusBadge status="..." type="order|appointment|part|invoice|staff" />
 * Render Badge màu sắc chuẩn theo trạng thái nghiệp vụ trong hệ thống
 */
public class StatusBadgeTag extends SimpleTagSupport {

    private String status;
    private String type = "order"; // order, appointment, part, invoice, staff

    public void setStatus(String status) {
        this.status = status;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public void doTag() throws JspException, IOException {
        JspWriter out = getJspContext().getOut();
        if (status == null || status.trim().isEmpty()) {
            out.print("<span class=\"badge bg-secondary\">—</span>");
            return;
        }

        String badgeClass = "badge-secondary";
        String label = status;

        if ("order".equalsIgnoreCase(type)) {
            label = FormatUtil.getOrderStatusText(status);
            badgeClass = FormatUtil.getOrderStatusBadgeClass(status);
        } else if ("appointment".equalsIgnoreCase(type)) {
            switch (status) {
                case "PENDING":
                    badgeClass = "badge-warning";
                    label = "Chờ tiếp nhận";
                    break;
                case "CONFIRMED":
                    badgeClass = "badge-info";
                    label = "Đã tiếp nhận";
                    break;
                case "COMPLETED":
                    badgeClass = "badge-success";
                    label = "Đã hoàn thành";
                    break;
                case "CANCELLED":
                    badgeClass = "badge-danger";
                    label = "Đã hủy";
                    break;
            }
        } else if ("invoice".equalsIgnoreCase(type)) {
            switch (status) {
                case "PAID":
                    badgeClass = "badge-success";
                    label = "Đã thanh toán";
                    break;
                case "UNPAID":
                    badgeClass = "badge-danger";
                    label = "Chưa thanh toán";
                    break;
                case "PARTIAL":
                    badgeClass = "badge-warning";
                    label = "Thanh toán 1 phần";
                    break;
            }
        } else if ("part".equalsIgnoreCase(type) || "staff".equalsIgnoreCase(type)) {
            if ("ACTIVE".equalsIgnoreCase(status)) {
                badgeClass = "badge-success";
                label = "Đang hoạt động";
            } else if ("INACTIVE".equalsIgnoreCase(status)) {
                badgeClass = "badge-secondary";
                label = "Tạm ngưng";
            } else if ("LOCKED".equalsIgnoreCase(status)) {
                badgeClass = "badge-danger";
                label = "Đã khóa";
            }
        }

        out.print(String.format("<span class=\"badge %s\">%s</span>", badgeClass, label));
    }
}
