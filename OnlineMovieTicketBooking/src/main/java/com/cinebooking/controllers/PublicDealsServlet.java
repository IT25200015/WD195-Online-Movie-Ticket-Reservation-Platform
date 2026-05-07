package com.cinebooking.controllers;

import com.cinebooking.models.Promotion;
import com.cinebooking.services.PromotionService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/deals")
public class PublicDealsServlet extends HttpServlet {

    private PromotionService promotionService;

    @Override
    public void init() throws ServletException {
        String dataPath = getServletContext().getRealPath("/");
        promotionService = new PromotionService(dataPath);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Promotion> activePromotions = promotionService.getActiveValidPromotions();
        request.setAttribute("activePromotions", activePromotions);
        
        request.getRequestDispatcher("/public/deals.jsp").forward(request, response);
    }
}
