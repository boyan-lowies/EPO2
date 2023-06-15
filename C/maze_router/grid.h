#ifndef GRID_H_
#define GRID_H_

// Define the dimensions of the grid
#define ROWS 11
#define COLS 11

// The x and y coordinate pairs of all the stations
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
    {7, 0},
    {5, 0},
    {3, 0}};

#endif