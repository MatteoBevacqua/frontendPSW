class Constants {
  // app info
  static final String APP_VERSION = "0.0.1";
  static final String APP_NAME = "Journey Planner";

  // addresses
  static final String SERVER_ADDRESS = "journeyrestapi.ddns.net:8080";
  static final String ADDRESS_AUTHENTICATION_SERVER = "journeyrestapi.ddns.net:8443";

  // authentication
  static final String REALM = "journey_planner";
  static final String CLIENT_ID = "spring-boot";
  static final String CLIENT_SECRET = "***";
  static final String REQUEST_LOGIN = "/auth/realms/" + REALM + "/protocol/openid-connect/token";
  static final String REQUEST_LOGOUT = "/auth/realms/" + REALM + "/protocol/openid-connect/logout";
  static final String CITY_AUTOFILL_ENDPOINT = "/cities/search/like";
  static final String GET_SEATS = "/seats/byRouteWithSelectionStatus";
  static final String GET_RESERVATIONS = "/all";
  static final String MAKE_RESERVATION  = "/reservations";
  static final String DELETE_RESERVATION = "/reservations";
  static final String RESERVATIONS = "/reservations";
  static final String UPDATE_SEATS_BACKGROUND = "/routes/seatsLeft";
  // requests

  static final String REQUEST_ADD_PASSENGER = "/users";
  static final String CITIES = "/cities";
  static final String REQUEST_GET_ROUTES = "/routes";
  static final String REQUEST_GET_FASTEST_ROUTE = "/fastestRoute";

  static final String ROUTE_BY_ARRIVAL = "/search/byArrivalCity";
  static final String ROUTE_BY_DEPARTURE = "/search/byDepartureCity";
  static final String ROUTE_BY_BOTH = "/search/byDepartureAndArrivalCity";
  static final String ALL_ROUTES = "/all";
  static final String ROUTES = "/routes";
  static final String ROUTE_BY_ID = "/getById";


  // responses
  static final String RESPONSE_ERROR_MAIL_USER_ALREADY_EXISTS = "ERROR_MAIL_USER_ALREADY_EXISTS";

  // messages
  static final String MESSAGE_CONNECTION_ERROR = "connection_error";


}