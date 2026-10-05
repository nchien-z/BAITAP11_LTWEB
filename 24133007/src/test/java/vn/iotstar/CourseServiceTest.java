package vn.iotstar;

import junit.framework.TestCase;
import vn.iotstar.entity.*;
import vn.iotstar.service.CourseService_24133007;

public class CourseServiceTest extends TestCase {
    public void testPublicVideoIsFreeAndPrivateRequiresLogin() throws Exception {
        Video_24133007 video = new Video_24133007(); video.setActive(true);
        CourseService_24133007 service = new CourseService_24133007();
        assertTrue(service.canWatch(video,null));
        video.setPrivateVideo(true); assertFalse(service.canWatch(video,null));
        assertFalse(service.canWatch(video,new User_24133007()));
        video.setActive(false); assertFalse(service.canWatch(video,null));
        User_24133007 admin=new User_24133007();admin.setAdmin(true);assertTrue(service.canWatch(video,admin));
    }
    public void testActivationRejectsGuestAndMalformedCode() throws Exception {
        CourseService_24133007 service=new CourseService_24133007();
        try {service.activate(null,"code");fail();} catch(IllegalArgumentException expected) { }
        for(String code:new String[]{"","123","not-a-valid-code"}) {
            try {service.activate(new User_24133007(),code);fail();} catch(IllegalArgumentException expected) { }
        }
    }
}
