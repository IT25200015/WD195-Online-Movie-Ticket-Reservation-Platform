package com.cinebooking.controllers;

import com.cinebooking.services.PromotionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/promotions/analytics")
public class PromotionAnalyticsServlet extends HttpServlet {

    private PromotionService promotionService;

    @Override
    public void init() throws ServletException {
        String dataPath = getServletContext().getRealPath("/");
        promotionService = new PromotionService(dataPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        int totalCodes = promotionService.getTotalCodesCount();
        int totalRedemptions = promotionService.getTotalRedemptions();
        
        request.setAttribute("totalCodes", totalCodes);
        request.setAttribute("totalRedemptions", totalRedemptions);
        
        // Pass to JSP
        request.getRequestDispatcher("/admin/promotion-analytics.jsp").forward(request, response);
    }
}
