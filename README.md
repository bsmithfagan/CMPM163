Click anywhere to transition from part A to part B, B to C, or C to A.

Part A has one shader which applies a texture to the cylinder, one which inverts the vertices of the raccoon, and one which applies a texture and multi-lit Phong shading to the capsule.

Part B has a pixel shader, the size of the pixels will increase depending on how far the cursor is to the right of the screen.

Part C is a cellular automata in which each cell has 3 values: r, g, and b; and each value is compared to that of its neighbors to determine whether or not to increase it. 2 or more neighbors with equal or higher of that value means that it will increase, but once it reaches 1, it is reset to 0. This causes colorful waves to emanate from points where this behavior begins to emerge.
