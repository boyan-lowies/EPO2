#include <stdio.h>
#include <stdlib.h>
#include <Windows.h>
#include <string.h>

#include "maze_router/maze_router.h"
#include "serial.h"

HANDLE hSerial;
char byteBuffer[BUFSIZ + 1];

void initSerial()
{
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
    //
    int stations[3] = {5,7,10};
    Node *current = challengeA(stations);

    printPath(current);

    // Type an 's' in the terminal to start
    while (1)
    {
        gets(byteBuffer);
        if (byteBuffer[0] == 's')
            break;
    }

    // Send first direction
    int angle = nodeDetected(current->next);
    printf("Angle to next node: %i\n", angle);
    byteBuffer[0] = (char)angle;
    writeByte(hSerial, byteBuffer);

    while (1)
    {
        readByte(hSerial, byteBuffer);

        // Break out of loop when finished
        if (current->next == NULL) {
            byteBuffer[0] = (char)4;
            writeByte(hSerial, byteBuffer);
            break;
        }

        // Node reached
        if (byteBuffer[0] == 'z')
        {
            current = current->next;
            printf("Node reached: (%d,%d)\n", current->x, current->y);
            byteBuffer[0] = (char)1;
        }

        // Next angle update requested
        else if (byteBuffer[0] == 'q')
        {
            int angle = nodeDetected(current->next);
            
            if (angle == 3)
                angle = 2;

            printf("Angle to next node: %i\n", angle);
            byteBuffer[0] = (char)angle;
            writeByte(hSerial, byteBuffer);
        }
    }

    printf("ZIGBEE IO DONE!\n");
}

int nodeAfterMine = 0;

void runChallengeB()
{
    int stations_reached = 0;
    int stations[3] = {9, 6, 9};

    Node *src = createNode(0, 3, 0, 0, NULL, NULL);
    Node *dest = createNode(STATIONS[stations[0] - 1][0], STATIONS[stations[0] - 1][1], 0, 0, NULL, NULL);

    Node *current = AStarSearch(grid, src, dest);

    printPathInGrid(grid, current);
    
    // Type an 's' in the terminal to start
    while (1)
    {
        gets(byteBuffer);
        if (byteBuffer[0] == 's')
            break;
    } 

    // Send first direction
    int angle = nodeDetected(current->next);
    printf("Angle to next node: %i\n", angle);
    byteBuffer[0] = (char)angle;
    writeByte(hSerial, byteBuffer);

    while (1)
    {
        readByte(hSerial, byteBuffer);

        printf("%d\n", byteBuffer[0]);

        // Node reached
        if (byteBuffer[0] == 'z')
        {
            if (nodeAfterMine == 1)
            {
                nodeAfterMine = 0;
                            int angle = nodeDetected(current->next);
            printf("Angle to next node: %i\n", angle);
            byteBuffer[0] = (char)angle;
            writeByte(hSerial, byteBuffer);
            }

            printf("Node reached\n");
            current = current->next;
            printf("Current node: (%d,%d)\n", current->x, current->y);
            byteBuffer[0] = (char)1;

            if (current->x == dest->x && current->y == dest->y)
            {
                printf("Destination reached");
                stations_reached++;

                if (stations_reached == 3) {
                    printf("Last destination reached");
                }

                dest->x = STATIONS[stations[stations_reached] - 1][0];
                dest->y = STATIONS[stations[stations_reached] - 1][1];

                printf("Calculating route to next destination");
                current = AStarSearch(grid, current, dest);
                printPathInGrid(grid, current);
            }
        }

        // Next angle update requested
        else if (byteBuffer[0] == 'q')
        {
            int angle = nodeDetected(current->next);
            printf("Angle to next node: %i\n", angle);
            byteBuffer[0] = (char)angle;
            writeByte(hSerial, byteBuffer);
        }

        // Minde detected
        else if (byteBuffer[0] == 'm')
        {
            if (nodeAfterMine == 1)
                return;

            printf("Mine detected at node (%d,%d)\n", current->next->x, current->next->y);

            // Update mines
            grid[current->next->y][current->next->x] = 1;

            // stop
            byteBuffer[0] = (char)3;
            writeByte(hSerial, byteBuffer);

            Node *previous = createNode(current->next->x, current->next->y, 0, 0, NULL, NULL);
            current = createNode(current->x, current->y, 0, 0, previous, NULL);

            printf("Calculating route to next destination\n");
            current = AStarSearch(grid, current, dest);
            printf("A star finished\n");
            printPath(current);
            printPathInGrid(grid, current);

            nodeAfterMine = 1;
        }

        // Break out of loop when finished
        if (current->next == NULL) {
            byteBuffer[0] = (char)4;
            writeByte(hSerial, byteBuffer);
            printf("No next node");
            break;
        }
    }

    printf("ZIGBEE IO DONE!\n");
}

int main()
{

    initSerial();

    // runChallengeA();

    runChallengeB();

    CloseHandle(hSerial);

    return 0;
}
