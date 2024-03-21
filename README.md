# MAC 
MAC (multiply-accumulate) modules are essential to perform dot-product operations on the elements of the two matrices being multiplied.
A basic hardware solution to multiply two 8x8 matrices is to have one MAC that iterates on all the column-row pairs of the two matrices 
( e.g. [row1-col1] &#8594; [row2-col2] &#8594; ... &#8594; [row(n)-col(n)] ). 

# Parallelism with Multiple MACs
Using one MAC module for a small 8x8 operation is indeed enough and naive iteration for small operations is decently fast for modern systems. However, using such a 
technique for huge matrix multiplication operations result in large clock times. This means more processor/cpu usage and this technique does
not really take advantage of all the hardware present in a system, or in this case the FPGA that is being used for this operation.

Parallelism with eight MAC modules is one of optimization techniques that can be used at the cost of code complexity and hardware requirements ( e.g. more registers or other hardware needed ). 
Nevertheless, the main goal with parallelism in matrix multiplication like this is to increase throughput and thereby reduce total operation clock time. In other words, speed.

In this extreme example, eight MAC modules are used for each column-row pair:

( e.g. MAC1[row1-col1] : MAC2[row2-col2] : ... : MAC(n)[row(n)-col(n)] )

Each of the eight MAC modules are responsible for calculating their respective sections and run side by side with each other.

# Drawbacks and Buffer Usages
One of the goals of this project is to write the resulting matrix to the RAM of an FPGA. Because of the throughput increase caused by adding multiple MAC modules,
a bottleneck can occur when writing to RAM because only one module is responsible for the writing process. To solve such bottleneck,
a buffer can be used to temporarily store the results and have them written to the RAM sequentially. This solution requires more hardware. However,
one benefit of using buffers is that it can deal with the randomness of how fast a MAC module can finish an operation. 

Perhaps another solution that can be used to address the bottleneck issue is to have multiple modules attempting to write to RAM, and thus adding
another level of parallelism. With these issues having talked about, it is now clear to see why parallelism introduces complexity to the implementation.

# Results

<p align="center">
  <img src="https://github.com/PaimonCodes/8x8_matrix_multiply_mac8/assets/104661175/354b8816-fbd9-4395-8bb1-93e974ee687a" alt="image"><br>
  <em>Figure[1]: Simulated results. RAM output with total clock count of 76 (last rising edge).</em>
</p>

Although the MAC modules ran parallely, writing to the RAM was done sequentially with the help of buffers. This results into the "ladder-like" order sequence for
the writing of each final resulting matrix values. 

<p align="center">
  <img src="https://github.com/PaimonCodes/8x8_matrix_multiply_mac8/assets/104661175/d05e3585-d800-494e-b433-78685c9758bc" alt="image"><br>
  <em>Figure[2]: Simulated results. Error checking.</em>
</p>
