package com.cinebooking.controllers;

import com.cinebooking.models.FixedAmountDiscount;
import com.cinebooking.models.PercentageDiscount;
import com.cinebooking.models.Promotion;
import com.cinebooking.models.SeasonalPromotion;
import com.cinebooking.services.PromotionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/promotions")
public class AdminPromotionServlet extends HttpServlet {

    private PromotionService promotionService;

    @Override
    public void init() throws ServletException {
        String dataPath = getServletContext().getRealPath("/");
        promotionService = new PromotionService(dataPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // List all promotions by default
        List<Promotion> promotions = promotionService.getAllPromotions();
        request.setAttribute("promotions", promotions);
        request.getRequestDispatcher("/admin/promotions-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("create".equals(action) || "update".equals(action)) {
                String code = request.getParameter("promoCode");
                String type = request.getParameter("type");
                double discountValue = Double.parseDouble(request.getParameter("discountValue"));
                LocalDate startDate = LocalDate.parse(request.getParameter("startDate"));
                LocalDate endDate = LocalDate.parse(request.getParameter("endDate"));
                int usageLimit = Integer.parseInt(request.getParameter("usageLimit"));
                double minimumAmount = Double.parseDouble(request.getParameter("minimumAmount"));
                
                Promotion promo = null;
                
                if ("PERCENTAGE".equals(type)) {
                    promo = new PercentageDiscount(code, discountValue, startDate, endDate, usageLimit, minimumAmount);
                } else if ("FIXED".equals(type)) {
                    promo = new FixedAmountDiscount(code, discountValue, startDate, endDate, usageLimit, minimumAmount);
                } else if ("SEASONAL".equals(type)) {
                    String seasonName = request.getParameter("seasonName");
                    promo = new SeasonalPromotion(code, discountValue, startDate, endDate, usageLimit, minimumAmount, seasonName);
                }

                if (promo != null) {
                    if ("create".equals(action)) {
                        boolean created = promotionService.createPromotion(promo);
                        if(created) {
                            request.getSession().setAttribute("successMessage", "Promotion successfully created.");
                        } else {
                            request.getSession().setAttribute("errorMessage", "Promotion code already exists.");
                        }
                    } else if ("update".equals(action)) {
                        // Keep previous usage count when updating
                        Promotion existing = promotionService.getPromotionByCode(code);
                        if(existing != null) {
                            promo.setUsageCount(existing.getUsageCount());
                            promo.setActive(existing.isActive());
                            promotionService.updatePromotion(promo);
                            request.getSession().setAttribute("successMessage", "Promotion successfully updated.");
                        }
                    }
                }
            } else if ("delete".equals(action)) {
                String code = request.getParameter("code");
                if (code != null && !code.trim().isEmpty()) {
                    boolean removed = promotionService.deletePromotion(code.trim());
                    if (removed) {
                        request.getSession().setAttribute("successMessage", "Promotion successfully deleted.");
                    } else {
                        request.getSession().setAttribute("errorMessage", "Promotion could not be found or deleted.");
                    }
                }
            } else if ("toggle".equals(action)) {
                String code = request.getParameter("code");
                if (code != null && !code.trim().isEmpty()) {
                    Promotion promo = promotionService.getPromotionByCode(code.trim());
                    if (promo != null) {
                        promo.toggleStatus();
                        promotionService.updatePromotion(promo);
                        request.getSession().setAttribute("successMessage", "Promotion status updated.");
                    }
                }
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error parsing form data: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/promotions");
    }
}
