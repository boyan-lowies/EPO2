#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>

#define ROWS 11
#define COLS 11

/// @brief The x and y coordinate pairs of all the stations
const int STATIONS[12][2] = {
    {0, 3},
    {0, 5},
    {0, 7},
    {3, 10},
    {5, 10},
    {7, 10},
    {10, 7},
    {10, 5},
    {10, 3},
    {7, 3},
    {5, 3},
    {3, 3}};

/// @brief Define a structure to hold Node data
typedef struct Node
{
  int x, y;            /// node coordinates
  int g;               // cost from start node to current node
  int h;               // heuristic estimate of cost from current node to goal node
  int f;               // total estimated cost of the node (f=g+h)
  struct Node *parent; // pointer to parent Node
  struct Node *next;   // pointer to next Node
} Node;

/// @brief Create a node from input data
/// @param x
/// @param y
/// @param g
/// @param h
/// @param parent
/// @param next
/// @return A pointer to the created node
Node *createNode(int x, int y, int g, int h, Node *parent, Node *next)
{
  Node *node = (Node *)malloc(sizeof(Node));
  node->x = x;
  node->y = y;
  node->g = g;
  node->h = h;
  node->f = g + h;
  node->parent = parent;
  node->next = next;
  return node;
}

/// @brief Check if given coordinates match the destination
/// @param x
/// @param y
/// @param dest
/// @return 1 if at destination, 0 otherwise
int isDestination(int x, int y, Node *dest)
{
  return x == dest->x && y == dest->y;
}

/// @brief Check if given coordinates are in the grid
/// @param x
/// @param y
/// @return 1 if in grid, 0 otherwise
int isValid(int x, int y)
{
  return x >= 0 && x < ROWS && y >= 0 && y < COLS;
}

/// @brief Check if given coordinates correspond to an unblocked node
/// @param grid
/// @param x
/// @param y
/// @return 1 if unblocked, 0 if blocked
int isUnBlocked(int grid[][COLS], int x, int y)
{
  return grid[x][y] == 0;
}

/// @brief
/// @param x
/// @param y
/// @param dest
/// @return
int heuristic(int x, int y, Node *dest)
{
  return abs(x - dest->x) + abs(y - dest->y);
}

/// @brief Print the coordinates of the path
/// @param node The destination of the path
void printPathCoordinates(Node *node)
{
  if (node->parent == NULL)
  {
    printf("(%d,%d) ", node->x, node->y);
    return;
  }
  printPathCoordinates(node->parent);
  printf("(%d, %d) ", node->x, node->y);
}

/// @brief Utility function to check whether given coordinates correspond to a node in the calculated path
/// @param x
/// @param y
/// @param head
/// @return
int nodeInPath(int x, int y, Node *head)
{
  Node *current = head;

  while (current != NULL)
  {
    if (current->x == x && current->y == y)
    {
      return 1;
    }
    current = current->next;
  }

  return 0;
}

/// @brief Trace the path to its start and add next references to each node
/// @param node The destination
/// @return The start of the path
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

/// @brief Print the grid and highlight the path
/// @param grid
/// @param head Start of the path
void printPathInGrid(int grid[][COLS], Node *head)
{
  printf("\n\n");
  for (int i = 0; i < ROWS; i++)
  {
    for (int j = 0; j < COLS; j++)
    {
      if (grid[i][j])
      {
        // Blocked nodes are not printend
        printf("     ");
      }
      else if (nodeInPath(j, i, head))
      {
        // Unblocked nodes are printed as a hashtag
        // The color changes depending on whether the node is in the path
        printf("\033[32mX    \033[0m");
      }
      else
      {
        printf("#    ");
      }
    }
    printf("\n\n");
  }
}

void AStarSearch(int grid[][COLS], Node *src, Node *dest)
{
  if (!isValid(src->x, src->y) || !isValid(dest->x, dest->y))
  {
    printf("Invalid source or destination\n");
    return;
  }

  if (!isUnBlocked(grid, src->x, src->y) || !isUnBlocked(grid, dest->x, dest->y))
  {
    printf("Source or destination is blocked\n");
    return;
  }

  if (isDestination(src->x, src->y, dest))
  {
    printf("Already at the destination\n");
    return;
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
          printPathCoordinates(dest);
          Node *head = tracePath(dest);
          printPathInGrid(grid, head);
          return;
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
}

void challengeA(int stations[3])
{
  // The standard grid is used without mines
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

  // The robot starts at station 1
  Node *src = createNode(0, 3, 0, 0, NULL, NULL);

  // The robot has to visit 3 stations
  for (int i = 0; i < 3; i++)
  {
    // Get the station coordinates
    const int x = STATIONS[stations[i] - 1][0];
    const int y = STATIONS[stations[i] - 1][1];

    // Create a destination node
    Node *dest = createNode(x, y, 0, 0, NULL, NULL);

    // Find a path from src to dest
    AStarSearch(grid, src, dest);

    // Update src
    src = dest;
  }
}

void challengeB(int stations[3])
{
  // The standard grid is used without mines
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
  
  // When a mine is detected, update grid
  // grid[row][col] = 1;

}

int main()
{
  int stations[3] = {2, 7, 6};
  challengeA(stations);



  return 0;
}