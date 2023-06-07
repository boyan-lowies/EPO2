#ifndef NODE_H_
#define NODE_H_

/**
 * @typedef Node
 * @brief A structure to represent a node in the grid
 */
typedef struct Node
{
  int x, y;            /// node coordinates
  int g;               // cost from start node to current node
  int h;               // heuristic estimate of cost from current node to goal node
  int f;               // total estimated cost of the node (f=g+h)
  struct Node *parent; // pointer to parent Node
  struct Node *next;   // pointer to next Node
} Node;

/**
 * @brief Utility function that creates a node.
 *
 * @param x
 * @param y
 * @param g
 * @param h
 * @param parent
 * @param next
 * @return A pointer to the created node.
 */
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

#endif