package com.cinebooking.controllers;

import com.cinebooking.models.Promotion;
import com.cinebooking.services.PromotionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/api/validate-promo")
public class PromoValidationServlet extends HttpServlet {

    private PromotionService promotionService;

    @Override
    public void init() throws ServletException {
        String dataPath = getServletContext().getRealPath("/");
        promotionService = new PromotionService(dataPath);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String code = request.getParameter("promoCode");
        String bookingAmountStr = request.getParameter("bookingAmount");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            double bookingAmount = Double.parseDouble(bookingAmountStr);
            
            Promotion promo = promotionService.getPromotionByCode(code);
            if (promo == null) {
                out.print("{\"success\": false, \"message\": \"Invalid promo code.\"}");
                return;
            }

            if (!promo.isActive()) {
                out.print("{\"success\": false, \"message\": \"Promo code is no longer active.\"}");
                return;
            }

            if (!promo.isValidForUse(bookingAmount)) {
                out.print("{\"success\": false, \"message\": \"Conditions not met (amount threshold, usage limits, or expired).\"}");
                return;
            }

            double discount = promo.calculateDiscount(bookingAmount);
            double newTotal = bookingAmount - discount;
            
            // To simulate successful use at checkout we might call promotionService.recordPromoCodeUsage(code);
            // But this is just a validation API
            
            out.print(String.format("{\"success\": true, \"discount\": %.2f, \"newTotal\": %.2f, \"message\": \"Promo code applied successfully!\"}", discount, newTotal));

        } catch (Exception e) {
            out.print("{\"success\": false, \"message\": \"Internal processing error.\"}");
            e.printStackTrace();
        }
        out.flush();
    }
}
