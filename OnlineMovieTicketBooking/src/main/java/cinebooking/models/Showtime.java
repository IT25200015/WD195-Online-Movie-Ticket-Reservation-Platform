package cinebooking.models;

public class Showtime {
    private int showtime_id;
    private int movie_id;
    private String day;
    private String start_time;
    private String end_time;

    // Constructor
    public Showtime(int showtime_id, int movie_id, String day, String start_time, String end_time) {
        this.showtime_id = showtime_id;
        this.movie_id = movie_id;
        this.day = day;
        this.start_time = start_time;
        this.end_time = end_time;
    }

    // Getters and Setters
    public int getShowtime_id() {
        return showtime_id;
    }

    public void setShowtime_id(int showtime_id) {
        this.showtime_id = showtime_id;
    }

    public int getMovie_id() {
        return movie_id;
    }

    public void setMovie_id(int movie_id) {
        this.movie_id = movie_id;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public String getStart_time() {
        return start_time;
    }

    public void setStart_time(String start_time) {
        this.start_time = start_time;
    }

    public String getEnd_time() {
        return end_time;
    }

    public void setEnd_time(String end_time) {
        this.end_time = end_time;
    }

    // Convert object to file string
    public String toFileString() {
        return showtime_id + "," + movie_id + "," + day + "," + start_time + "," + end_time;
    }

    // Convert file string to object
    public static Showtime fromFileString(String line) {
        String[] data = line.split(",");

        int showtime_id = Integer.parseInt(data[0]);
        int movie_id = Integer.parseInt(data[1]);
        String day = data[2];
        String start_time = data[3];
        String end_time = data[4];

        return new Showtime(showtime_id, movie_id, day, start_time, end_time);
    }
}
