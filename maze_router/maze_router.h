#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <math.h>

#include "node.h"
#include "grid.h"
#include "a_star.h"
#include "visuals.h"

int grid[ROWS][COLS] = {
    {1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1}};

int nodeDetected(Node *current) {
  int previous_dx = 1;
  int previous_dy = 0;

  if (current->parent != NULL) {
    previous_dx = current->x - current->parent->x;
    previous_dy = current->y - current->parent->y;
  }    

  int dx = current->next->x - current->x;
  int dy = current->next->y - current->y;

  double theta = atan2(
    previous_dx * dy - previous_dy * dx, 
    previous_dx * dx + previous_dy * dy
  );

  // 0 = -90deg, 1 = 0deg, 2 = 90deg, 3 = 180deg
  int angle = (int) (theta / M_PI * 180) / 90 + 1;

  return angle;
}

/**
 * @brief Challenge A
 * 
 * @param stations All the stations that should be visited
 * @return The start of the path
 */
Node *challengeA(int stations[3])
{
  // The robot starts at station 1
  Node *src = createNode(0, 3, 0, 0, NULL, NULL);

  // The head of the path
  Node *head = src;

  // The robot has to visit 3 stations
  for (int i = 0; i < 3; i++)
  {
    // Get the station coordinates
    const int x = STATIONS[stations[i] - 1][0];
    const int y = STATIONS[stations[i] - 1][1];

    // Create a destination node
    Node *dest = createNode(x, y, 0, 0, NULL, NULL);

    // Find a path from src to dest
    head = AStarSearch(grid, src, dest);

    // Update src
    src = dest;
  }

  return head;
}

int count_path(Node* head) {
  
}