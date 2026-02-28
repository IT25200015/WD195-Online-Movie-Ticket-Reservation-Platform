# WD195 - Online Movie Ticket Booking Platform

## Project Overview
The Online Movie Ticket Booking Platform is a web-based application developed for the SE1020 Object Oriented Programming module. The system enables users to browse movies, select showtimes, choose seats, make payments, apply promotional discounts, and leave reviews. Data is persisted using file read/write operations on plain text files, with a MySQL connection.

## Group Details
* **Group:** WD195
* **Module Code:** SE1020
* **Module Name:** Object Oriented Programming

### Team Members & Component Breakdown
| # | Component | Assigned Student ID |
| :--- | :--- | :--- |
| 01 | User Account Management | [Add ID Here] |
| 02 | Movie & Showtime Management | [Add ID Here] |
| 03 | Seat Selection & Booking Management | [Add ID Here] |
| 04 | Payment & Transaction Management | [Add ID Here] |
| 05 | Promotion & Discount Management | [Add ID Here] |
| 06 | Review, Rating & Feedback Management | [Add ID Here] |

## Technology Stack
* **Language:** Java (JDK 17+)
* **Backend Framework:** Spring Boot / JSP Servlets
* **Frontend:** HTML5, CSS3, JavaScript (ES6)
* **UI Framework:** Bootstrap 5 or Tailwind CSS
* **Data Storage:** File ReadWrite /(.txt) and MySQL
* **Development Environment:** IntelliJ IDEA
* **Version Control:** GitHub
* **Server:** Apache Tomcat (embedded via Spring Boot)

## Architecture & OOP Principles
The application follows a layered MVC (Model-View-Controller) architecture. 

The system applies all five OOP principles across all six components:
* **Encapsulation:** All entity classes use private fields with public getters/setters.
* **Inheritance:** Specialised subclasses extend base classes (e.g., AdminUser extends User).
* **Polymorphism:** Method overriding across subclasses (e.g., calculatePrice(), getDisplayCard()).
* **Abstraction:** Abstract classes and interfaces define contracts without exposing implementation details.
* **Information Hiding:** File I/O and business logic hidden inside service classes.

## Folder Structure
* `src/main/java/com/cinebooking/` - Contains all Java POJO classes, Servlets, and Services.
* `src/main/webapp/WEB-INF/views/` - Contains all JSP files for the frontend user interface.
* `data/` - Contains all `.txt` files used for data storage (e.g., users.txt, movies.txt, showtimes.txt).
* `docs/` - Contains Class diagrams and the Final Report.
