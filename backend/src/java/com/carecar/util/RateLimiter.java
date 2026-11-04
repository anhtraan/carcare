package com.carecar.util;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.TimeUnit;

/**
 * In-memory IP-based Sliding Window Rate Limiter
 * Phòng chống tấn công quét tự động (Brute-force / Scraping / Enumeration)
 */
public class RateLimiter {

    private static class RequestTracker {
        long windowStart;
        int count;

        RequestTracker(long windowStart, int count) {
            this.windowStart = windowStart;
            this.count = count;
        }
    }

    private final int maxRequests;
    private final long windowMillis;
    private final ConcurrentHashMap<String, RequestTracker> trackers = new ConcurrentHashMap<>();

    public RateLimiter(int maxRequests, long duration, TimeUnit unit) {
        this.maxRequests = maxRequests;
        this.windowMillis = unit.toMillis(duration);
    }

    /**
     * Kiểm tra xem IP hoặc Key này có được phép thực hiện request tiếp theo hay không
     * @param key Khóa định danh (thường là Client IP Address)
     * @return true nếu còn trong giới hạn cho phép, false nếu vượt ngưỡng
     */
    public boolean allowRequest(String key) {
        if (key == null || key.isEmpty()) {
            key = "UNKNOWN";
        }
        long now = System.currentTimeMillis();

        // Dọn dẹp định kỳ để tránh tràn bộ nhớ nếu số lượng IP quá lớn
        if (trackers.size() > 5000) {
            trackers.entrySet().removeIf(e -> (now - e.getValue().windowStart) > windowMillis * 2);
        }

        RequestTracker tracker = trackers.compute(key, (k, existing) -> {
            if (existing == null || (now - existing.windowStart) >= windowMillis) {
                return new RequestTracker(now, 1);
            } else {
                existing.count++;
                return existing;
            }
        });

        return tracker.count <= maxRequests;
    }

    public void reset(String key) {
        if (key != null) {
            trackers.remove(key);
        }
    }
}
