package co.yperea.service;

import co.yperea.application.ManagerFactory;
import co.yperea.domain.User;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;
import java.util.List;

/**
 * Process HTTP requests for User entity.
 */
@Path("/users")
public class Users {

    /**
     * Returns a Users json-list for a HTTP GET request when no user Id has been specified.
     *
     * @return the message
     * @throws JsonProcessingException the json processing exception
     */
    @GET
    @Produces({MediaType.APPLICATION_JSON})
    @Path("/")
    @Transactional(Transactional.TxType.REQUIRED)
    public Response getUsersList() throws JsonProcessingException {

        ObjectMapper objectMapper = new ObjectMapper();
        List<User> users = ManagerFactory.getManager(User.class).getList();
        String json = objectMapper.writeValueAsString(users);

        return Response.status(200)
                .entity(json)
                .build();
    }

    /**
     * Returns a Users json-object for a HTTP GET request when a user id has been specified.
     *
     * @return the message
     * @throws JsonProcessingException the json processing exception
     */
    @GET
    @Produces({MediaType.APPLICATION_JSON})
    @Path("/{userId}")
    @Transactional(Transactional.TxType.REQUIRED)
    public Response getUserById(
            @PathParam("userId") int userId,
            @Context HttpServletRequest request
    ) throws JsonProcessingException {

        ObjectMapper objectMapper = new ObjectMapper();
        User user = (User) ManagerFactory.getManager(User.class).get(userId);
        String json = objectMapper.writeValueAsString(user);

        return Response.status(200)
                .entity(json)
                .build();
    }
}
