/* RHEL5 Implementation of last function that also returns the year. C. */ 
#include <stdio.h>
#include <utmp.h>
#include <string.h>
#include <time.h>

int main(void) {
        struct utmp *line;
        time_t timestamp;
        utmpname("/var/log/wtmp");
        setutent();
        while( (line = getutent()) != NULL) {
                if (line->ut_type == USER_PROCESS ) {
                        timestamp = line->ut_tv.tv_sec;
                        printf("%s %s", line->ut_user, asctime(localtime(&timestamp)));
                }
        }
        endutent();
        return 0;
}

/* gcc -Wall clast.c -o clast */ 
