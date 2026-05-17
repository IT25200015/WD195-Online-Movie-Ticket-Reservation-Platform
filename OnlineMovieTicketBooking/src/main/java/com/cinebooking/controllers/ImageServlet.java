package com.cinebooking.controllers;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        String filename = request.getPathInfo().substring(1);

        String uploadPath =
                getServletContext()
                        .getRealPath("/images");

        File file = new File(uploadPath, filename);

        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String contentType =
                getServletContext().getMimeType(file.getName());

        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        response.setContentType(contentType);

        Files.copy(file.toPath(), response.getOutputStream());
    }
}