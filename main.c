#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>
#include <string.h>

#include "maze_router/maze_router.h"
#include "serial.h"

HANDLE hSerial;
char byteBuffer[BUFSIZ + 1];

void initSerial() {
    //----------------------------------------------------------
    // Open COMPORT for reading and writing
    //----------------------------------------------------------
    hSerial = CreateFile(COMPORT,
                         GENERIC_READ | GENERIC_WRITE,
                         0,
                         0,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

    if (hSerial == INVALID_HANDLE_VALUE)
    {
        if (GetLastError() == ERROR_FILE_NOT_FOUND)
        {
            // serial port does not exist. Inform user.
            printf(" serial port does not exist \n");
        }
        // some other error occurred. Inform user.
        printf(" some other error occured. Inform user.\n");
    }

    //----------------------------------------------------------
    // Initialize the parameters of the COM port
    //----------------------------------------------------------

    initSio(hSerial);
}

void runChallengeA()
{
    int stations[3] = {2, 7, 6};
    Node *current = challengeA(stations);
    
    gets(byteBuffer);
    while (1)
    {
        // gets(byteBuffer);

        // if (byteBuffer[0] == 'q') // end the loop by typing 'q'
        // break;

        // writeByte(hSerial, byteBuffer);
        readByte(hSerial, byteBuffer);

        if (byteBuffer[0] == 'z')
        {
            int angle = nodeDetected(current);
            current = current->next;
            byteBuffer[0] = (char)angle;
            writeByte(hSerial, byteBuffer);
        }
    }

    printf("ZIGBEE IO DONE!\n");
}

void runChallengeB() {
    int stations_reached = 0;
    int stations[3] = {2, 7, 6};

    Node* src = createNode(0, 3, 0, 0, NULL, NULL);
    Node *dest = createNode(STATIONS[stations[0] - 1][0], STATIONS[stations[0] - 1][1], 0, 0, NULL, NULL);

    Node *current = AStarSearch(grid, src, dest);
    
    gets(byteBuffer);
    while (1)
    {
        readByte(hSerial, byteBuffer);

        if (byteBuffer[0] == 'z')
        {
            int angle = nodeDetected(current);
            current = current->next;
            byteBuffer[0] = (char)angle;
            writeByte(hSerial, byteBuffer);
            if (current->x == dest->x && current->y == dest->y) {
                stations_reached++;
                dest->x = STATIONS[stations[stations_reached] - 1][0];
                dest->y = STATIONS[stations[stations_reached] - 1][1];
                current = AStarSearch(grid, current, dest);
            }
        } else if (byteBuffer[0] == 'm') {
            // Go back to previous node
            byteBuffer[0] = (char)3;
            writeByte(hSerial, byteBuffer);

            // Update mines
            grid[current->next->x][current->next->y] = 1;
            
            current = AStarSearch(grid, current, dest);
        }
    }

    printf("ZIGBEE IO DONE!\n");
}

int main()
{

    initSerial();

    runChallengeA();

    // runChallengeB();

    CloseHandle(hSerial);

    return 0;
}
