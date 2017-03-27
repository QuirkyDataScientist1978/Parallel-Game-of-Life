#include <stdio.h>
#include"cuda_runtime.h"
#include"device_launch_parameters.h"
#include <stdlib.h>
#include<time.h>
#include<iostream>
#include "optimized_kernel.h"
#include "simple_kernel.h"
#include "natural_indexed_kernel.h"
using namespace std;
//int SIZE, ITERATIONS, ANIMATE, BLOCKS, THREADS, SEED, UNOPTIMIZED, PRINT;
void print_board(int board[], int size, int iteration)
{
	if (iteration != -1)
	{
		printf("Iteration %d\n", iteration);
	}
	for (int i = 0;i < size; i++)
	{
		for (int j = 0; j < size; j++)
		{
			if (board[i * size + j] != 0 && board[i * size + j] != 1)
			{
				printf("%d", board[i * size + j]);
			}
			else
			{
				if (board[i * size + j])
				{
					cout << "*";
				}
				else
				{
					cout << "#";
				}
			}
		}
		printf("\n");
	}
	printf("\n\n");
}

int run()
{
	bool animate =true;
	int size =  20;
	int iterations = 200;
	int no_blocks = size;
	int no_threads =  size;
	int unoptimized_run =  1;
	bool print =  true;

	// Initialize random seed
	srand(time(NULL));

	// Allocate space on host
	int *input = (int*)calloc(size * size, sizeof(int));
	int *output = (int*)calloc(size * size, sizeof(int));
	int *devin, *devout, *devtemp;

	// Allocate space on device
	cudaMalloc((void**)&devin, size * size * sizeof(int));
	cudaMalloc((void**)&devout, size * size * sizeof(int));
	cudaMalloc((void**)&devtemp, size * size * sizeof(int));

	// Generate random input
	for (int i = 0;i < size; i++)
	{
		for (int j = 0; j < size; j++)
		{
			input[i*size + j] = rand() % 2;
			//printf("%d", rand() % 2);
		}
	}

	//timing events
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	if (print)
		print_board(input, size, 0);

	// Copy from host to device
	cudaMemcpy(devin, input, size * size * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(devout, output, size * size * sizeof(int), cudaMemcpyHostToDevice);

	int shared_board_size = (no_threads + 2 * size) * sizeof(int);
	// Call the chosen kernel and time the run
	//struct timeval  tv1, tv2;
	//gettimeofday(&tv1, NULL);
	clock_t time = clock();
	if (unoptimized_run)
	{
		printf(" kernel run\n");
		for (int i = 0;i<iterations;i++)
		{
			if (i == 0)
			{
				play_with_row_based_index << <no_blocks, no_threads >> > (devin, devout, size);
			}
			else
			{
				play_with_row_based_index<<<no_blocks, no_threads>>>(devtemp, devout, size);
			}
			cudaMemcpy(devtemp, devout, size * size * sizeof(int), cudaMemcpyDeviceToDevice);
			cudaMemcpy(output, devout, size * size * sizeof(int), cudaMemcpyDeviceToHost);
			if (animate == true)
			{
				system("clear");
				print_board(output, size, i);
				_sleep(100);
			}
		}
	}
	

	cudaMemcpy(output, devout, size * size * sizeof(int), cudaMemcpyDeviceToHost);
	if (print)
		print_board(output, size, iterations);
	printf("Total time in kernel = %f milliseconds\n", (float)(clock() - time) / CLOCKS_PER_SEC);
	cudaFree(devin);
	cudaFree(devout);
	cudaFree(devtemp);

	return 0;
}

int main(int argc, char* argv[])
{
	run();
	return 0;
}
