#include "node.h"
#include "grid.h"

/**
 * @brief Utility function that checks if the given coordinates are in the path.
 *
 * @param x The x coordinate to check.
 * @param y The y coordinate to check.
 * @param head The head of the list of nodes that forms the path.
 * @return Returns `1` if in path, and `0` otherwise.
 */
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

/**
 * @brief Print the grid and highlight the path
 * 
 * @param grid
 * @param head Start of the path
 */
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

/**
 * @brief Print the coordinates of the path
 * 
 * @param head The start node of the path
 */
void printPath(Node *head) {
  Node *current = head;
  while(current != NULL) {
    printf("(%d,%d)", current->x, current->y);
    current = current->next;
  }
}
