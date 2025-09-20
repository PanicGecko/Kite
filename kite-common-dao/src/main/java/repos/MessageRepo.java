package repos;

import org.springframework.data.cassandra.repository.CassandraRepository;
import org.springframework.data.cassandra.repository.Query;
import org.springframework.stereotype.Repository;
import pojo.Message_v2;

import java.sql.Timestamp;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Repository
public interface MessageRepo extends CassandraRepository<Message_v2, UUID> {

    @Query("SELECT * FROM message_v2 where chatid = ?0 and deliveredtime > ?1 ALLOW FILTERING")
    List<Message_v2> findByChatIdandTime(int chatId, Timestamp lastOpen);

    @Query("SELECT * FROM message_v2 where chatid = ?0 ALLOW FILTERING")
    List<Message_v2> findByChatId(int chatId);

    @Query("SELECT * FROM message_v2 WHERE id = ?0 ALLOW FILTERING")
    List<Message_v2> findAllFromIds(UUID ids);
}
