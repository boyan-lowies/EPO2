#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <math.h>

#include "node.h"
#include "grid.h"

/**
 * @brief Utility function that checks if the given coordinates correspond to a station
 */
int isStation(int x, int y)
{
  for (int i = 0; i < 12; i++)
  {
    if (x == STATIONS[i][0] && y == STATIONS[i][1])
    {
      return 1;
    }
  }
  return 0;
}

/**
 * @brief Utility function that checks if the given coordinates match a given node's coordinates.
 *
 * @param x The x coordinate to check.
 * @param y The y coordinate to check.
 * @param dest The node to compare with.
 * @return Returns `1` if coordinates match, and `0` otherwise.
 */
int isDestination(int x, int y, Node *dest)
{
  return x == dest->x && y == dest->y;
}

/**
 * @brief Utility function that checks if the given coordinates exist in the grid.
 *
 * @param x The x coordinate.
 * @param y The y coordinate.
 * @return Returns `1` if valid, and `0` otherwise.
 */
int isValid(int x, int y)
{
  return x >= 0 && x < ROWS && y >= 0 && y < COLS;
}

/**
 * @brief Utility function that checks if the given coordinates correspond to an unblocked node in the given grid
 *
 * @param grid The grid to validate against
 * @param x The x coordinate to check
 * @param y The y coordinate to check
 * @returns Returns `1` if node is unblocked, and `0` otherwise
 *
 */
int isUnBlocked(int grid[][COLS], int x, int y)
{
  return grid[y][x] == 0;
}

/**
 * @brief Utility funtion that calculates the heuristic value of a coordinate pair.
 *
 * @param x The x coordinate.
 * @param y The y coordinate.
 * @param dest The destination node.
 * @return The heuristic value.
 *
 */
int heuristic(int x, int y, Node *dest)
{
  return abs(x - dest->x) + abs(y - dest->y);
}

/**
 * @brief Trace the path to its start and add next references to each node
 *
 * @param node The destination
 * @return The start of the path
 */
Node *tracePath(Node *node)
{
  // Pointer to store the adress of the curent node
  Node *current = node;

  // If the current node has a parent
  while (current->parent != NULL)
  {
    // Set the next property of the parent to point to the current node
    // This creates the parent -> child connection
    current->parent->next = current;

    // Set current node to the parent of the current node
    current = current->parent;
  }

  // Return the head of the list, a.k.a the start of the path
  return current;
}

/**
 * @brief A star search algorithm
 *
 * @param grid
 * @param src Source node
 * @param dest Destination node
 * @return The head of the path
 */
Node *AStarSearch(int grid[][COLS], Node *src, Node *dest)
{
  if (!isValid(src->x, src->y) || !isValid(dest->x, dest->y))
  {
    printf("Invalid source or destination\n");
    return NULL;
  }

  if (!isUnBlocked(grid, src->x, src->y) || !isUnBlocked(grid, dest->x, dest->y))
  {
    printf("Source or destination is blocked\n");
    return NULL;
  }

  if (isDestination(src->x, src->y, dest))
  {
    printf("Already at the destination\n");
    return NULL;
  }

  int visited[ROWS][COLS];
  memset(visited, 0, sizeof(visited));

  int dx[] = {-1, 0, 1, 0};
  int dy[] = {0, 1, 0, -1};

  Node *openList[ROWS * COLS];
  int openListCount = 0;

  openList[0] = src;
  openListCount++;

  visited[src->x][src->y] = 1;

  while (openListCount > 0)
  {
    Node *current = openList[0];
    int currentIdx = 0;

    for (int i = 1; i < openListCount; i++)
    {
      if (openList[i]->f < current->f)
      {
        current = openList[i];
        currentIdx = i;
      }
    }

    openList[currentIdx] = openList[openListCount - 1];
    openListCount--;

    for (int i = 0; i < 4; i++)
    {
      int newX = current->x + dx[i];
      int newY = current->y + dy[i];

      if (isValid(newX, newY))
      {
        if (isDestination(newX, newY, dest))
        {
          dest->parent = current;
          return tracePath(dest);
        }
        else if (isUnBlocked(grid, newX, newY) && !visited[newX][newY])
        {
          visited[newX][newY] = 1;
          int gNew = current->g + 1;
          int hNew = heuristic(newX, newY, dest);
          Node *newNode = createNode(newX, newY, gNew, hNew, current, NULL);
          openList[openListCount] = newNode;
          openListCount++;
        }
      }
    }
  }
  printf("Could not find a path to the destination\n");
  return NULL;
}