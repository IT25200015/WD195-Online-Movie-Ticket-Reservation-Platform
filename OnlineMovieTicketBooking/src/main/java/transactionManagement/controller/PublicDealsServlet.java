package transactionManagement.controller;

public class PublicDealsServlet {
}
package com.cinebooking.controllers;

import com.cinebooking.models.Promotion;
import com.cinebooking.services.PromotionService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
        HttpSession session = request.getSession(false);
        Object sessionUser = session != null ? session.getAttribute("user") : null;
        if (sessionUser == null) {
            response.sendRedirect(request.getContextPath() + "/UserController?action=login");
            return;
        }

        List<Promotion> activePromotions = promotionService.getActiveValidPromotions();
        request.setAttribute("activePromotions", activePromotions);

        request.getRequestDispatcher("/public/deals.jsp").forward(request, response);
    }
}
