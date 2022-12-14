#include "EasyBMP.h"
#include <iostream>
#include <vector>
#include <algorithm> 
#include <string>
#include <iomanip>

#include <cuda.h>
#include <cuda_runtime.h>

using namespace std;

__global__ void kernel(float* arrayOutput, cudaTextureObject_t texObj, int width, int height) {		// Ядро, на котором вычисления выполняются параллельно на большом числе нитей

	int index_x = blockIdx.x * blockDim.x + threadIdx.x;  			// Глобальный индекс нити для x
	int index_y = blockIdx.y * blockDim.y + threadIdx.y;			// Глобальный индекс нити для y
	int array[9];								// Объявление массива без инициализации									
	int k = 0;								// Задание счетчика
	if ((index_x < width) && (index_y < height))				// Условие выходв зв границы изображения
	{
		for (int i = index_x-1; i <= index_x + 1; i++)			// Циклы для перебора всех точек изображения
		{
			for (int j = index_y-1; j <= index_y + 1; j++)
			{
				array[k] = (int)tex2D<float>(texObj, i, j);	// tex2D — выполняет поиск текстуры в заданном 2D-сэмплере
				k++;						// Увеличение значения счетчика
			}
		}
		for (int q = 0; q < 9; q++) 					// Значения интенсивности каждого пикселя сортируются по 
        		for (int w = 0; w < 8; w++) 				// возрастанию в окне 3 на 3 (сортировка пузырьком)
			{
            			if (array[w] > array[w + 1]) 
				{
               				float b = array[w]; 			// Создание временной переменной, в которой будет хранится значение предыдующего элемента
                			array[w] = array[w+ 1]; 		// В предыдущий элемент массива записывается значение последующего
               				array[w + 1] = b; 			// Конечная замена значений элементов
            			}
        		}
    		}
		arrayOutput[(index_x)  + (index_y)* (width)] = array[4];	// Выходной пиксель принимает значение 5 элемента отсортированного массива

	}
}

void moveCursor(std::ostream& os, int col, int row)				// Функция перемещения курсора
{
  os << "\033[" << col << ";" << row << "H";					// Выполнение абсолютного позиционирования курсора
}


int MedianFilter(vector<vector<int>> image, int verctical, int gorizontal) {	// Медианный фильтр на CPU
	vector<int> array;							// Задание массива векторов

	for (int i = verctical - 1; i <= verctical + 1; i++)			// Циклы для прохода по всему изображению
	{
		for (int j = gorizontal - 1; j <= gorizontal + 1; j++)
		{
			array.push_back(image[i][j]);				// Вставка элементов в вектор сзади	
		}
	}
	sort(array.begin(), array.end());					// Сортировка элементов
	return array[4];							// Функция MedianFilter возвращает значение 
										// 5 элемента массива, которым и будет изменено значения 
										// пикселя "соль" или "перец"
}

vector<vector<int>> transformationImage(vector<vector<int>> image) {		// Функция изменения исходного изображения с применением 
										// медианного фильтра
	vector<vector<int>> output(image.size(), vector <int>(image[0].size()));// Создание выходного изображения

	for (int i = 1; i < image.size() - 1; i++)
	{
		for (int j = 1; j < image[0].size() - 1; j++)
		{
			output[i][j] = MedianFilter(image, i, j);		// Применение медианного фильтра
		}
	}
	return output;								// Возвращение созданной точки изображения
}

bool IsCudaSuccess(cudaError_t cudaError, const char* message)			// Проверка на верный запуск Cuda
{
	if (cudaError != cudaSuccess) {						// Если есть ошибка, то выводится ошибка
		fprintf(stderr, message);						
		fprintf(stderr, cudaGetErrorString(cudaError));
		fprintf(stderr, "\n");
		return false;
	}
	return true;								// Если ошибок нет, то все работает
}
int main()
{
	system ("clear");							// Очистка экрана в консоли
	BMP Input;								// Входящее изображение
	Input.ReadFromFile("input.bmp");					// Считывание изображения
	int width = Input.TellWidth();						// Вычисление ширины изображения
	int height = Input.TellHeight();					// Вычисление высоты изображения

	vector<vector<int>> a(width + 2, vector <int>(height + 2));		// Двумерный вектор с переменным количеством строк, где каждая строка является вектором

	for (int j = 0; j < height; j++)					// Перевод изображения в оттенки серого
	{
		for (int i = 0; i < width; i++)
		{
			int Temp = (int)floor(0.299 * Input(i, j)->Red + 0.587 * Input(i, j)->Green + 0.114 * Input(i, j)->Blue);
			a[i + 1][j + 1] = Temp;
		}
	}

	for (size_t j = 1; j < height - 1; j++)					// Обработка границ изображения
	{
		a[0][j] = a[1][j];
		a[width - 1][j] = a[width - 2][j];
	}
	for (size_t i = 1; i < width - 1; i++)					
	{
		a[i][0] = a[i][1];
		a[i][height - 1] = a[i][height - 2];
	}
	a[0][0] = a[1][1];							// Обработка углов изображения
	a[0][height - 1] = a[1][height - 2];					
	a[width - 1][0] = a[width - 2][1];
	a[width - 1][height - 1] = a[width - 2][height - 2];

	float* h_data = (float*)malloc(width * height * sizeof(float));		// Выделение памяти на CPU
	for (int i = 1; i < width+1; ++i)
		for (int j = 1; j < height+1; ++j)
			h_data[i * height + j] = a[i+1][j+1];

	cudaChannelFormatDesc channelDesc = cudaCreateChannelDesc(32, 0, 0, 0, cudaChannelFormatKindFloat); // Структура текстуры

	cudaArray_t arrayInput;										    // Входной массив для работы на GPU
	float* arrayOutput;										    // Выходной массив для работы на GPU

	cudaError_t cuerr = cudaMalloc((void**)&arrayOutput, width * height * sizeof(float));		    // Получение информации об указанном выходном cudaArray
	if (!IsCudaSuccess (cuerr, "Cannot allocate device Ouput array for a: ")) return 0;		    // Проверка можно ли выделить выходной массив

	cuerr = cudaMallocArray(&arrayInput, &channelDesc, width, height);				    // Получение информации об указанном входном cudaArray.
	if (!IsCudaSuccess (cuerr, "Cannot allocate device Input array for a: ")) return 0;		    // Проверка можно ли выделить входной массив

	cuerr = cudaMemcpy2DToArray(arrayInput, 0, 0, h_data, (width) * sizeof(float), (width) * sizeof(float), (height), cudaMemcpyHostToDevice); // Копирование данных между хостом и устройством
	if (!IsCudaSuccess (cuerr, "Cannot copy a array2D from host to device: ")) return 0;		    // Ошибка копирования данных

	struct cudaResourceDesc resDesc;						// Описание ресурса						    
	memset(&resDesc, 0, sizeof(resDesc));						// Инициализия значение памяти устройства
	resDesc.resType = cudaResourceTypeArray;					// На основе cudaArray
	resDesc.res.array.array = arrayInput;

	struct cudaTextureDesc texDesc;							// Описание текстуры
	memset(&texDesc, 0, sizeof(texDesc));						// Параметры текстуры
	texDesc.addressMode[0] = cudaAddressModeBorder; 				// Режим адресации (отсечения) текстурных координат Wrap
	texDesc.addressMode[1] = cudaAddressModeBorder;
	//texDesc.filterMode = cudaFilterModeLinear; 					// Режим фильтрации
	texDesc.readMode = cudaReadModeElementType;					// Режим чтения
	texDesc.normalizedCoords = 0; 							// Без использования нормализованной адресации

	cudaTextureObject_t texObj = 0;							// Создание объекта структуры
	cuerr = cudaCreateTextureObject(&texObj, &resDesc, &texDesc, NULL);
	if (!IsCudaSuccess (cuerr, "Cannot create TextureObject: ")) return 0;		// Ошибка создания структуры

  	cudaEvent_t start, stop;							// Создание обработчиков событий
  	float gpuTime = 0.0f;								// Начало отчета времени подсчета на GPU
  	cuerr = cudaEventCreate(&start);						// Создание события start
	if (!IsCudaSuccess(cuerr, "Cannot create CUDA start event: ")) return 0;	// Ошибка создания события start

   	cuerr = cudaEventCreate(&stop);							// Создание события stop
	if (!IsCudaSuccess(cuerr, "Cannot create CUDA end event: ")) return 0;		// Ошибка создания события stop

	dim3 BLOCK_SIZE(32, 32, 1);							// Задание размера блока
	dim3 GRID_SIZE(height  / 32 + 1, width/ 32 + 1, 1);				// Задание размера сетки

    	cuerr = cudaEventRecord(start, 0);						// Установка точки старта
    	if (cuerr != cudaSuccess) {							
        	fprintf(stderr, "Cannot record CUDA event: %s\n",			// Ошибка записи CUDA события
            	cudaGetErrorString(cuerr));						// Возвращает строковое представление имени перечисления кода ошибки
        	return 0;
    	}

	kernel << <GRID_SIZE, BLOCK_SIZE >> > (arrayOutput, texObj, width, height);	// Запуск ядра

	cuerr = cudaGetLastError();							// Возвращает последнюю ошибку из вызова среды выполнения
	if (!IsCudaSuccess (cuerr, "Cannot launch CUDA kernel: ")) return 0;		// Ошибка подключения к ядру CUDA

	cuerr = cudaDeviceSynchronize();						// Синхронизация устройств
	if (!IsCudaSuccess (cuerr, "Cannot synchronize CUDA kernel: ")) return 0;	// Ошибка синхронизации к ядру CUDA

	cuerr = cudaEventRecord(stop, 0);						// Создание события записи
	if (!IsCudaSuccess(cuerr, "Cannot copy c array from device to host: ")) return 0; // Ошибка копирования массива

	cuerr = cudaMemcpy(h_data, arrayOutput, width * sizeof(float) * height, cudaMemcpyDeviceToHost); // Копирует данные между хостом и устройством.

	if (!IsCudaSuccess(cuerr, "Cannot copy a array from device to host: ")) return 0; // Ошибка копирования массива	

	struct timespec mt1, mt2; 						// Создание структуры, содержащей интервал, разбитый на секунды и наносекунды
  	long double tt;		  						// Создание переменной времени
	clock_gettime(CLOCK_REALTIME, &mt1);					// Общесистемные часы реального времени для mt1

	a = transformationImage(a);						// Трансформированное изображение

	clock_gettime(CLOCK_REALTIME, &mt2);					// Общесистемные часы реального времени для mt1
  	tt=1000000000*(mt2.tv_sec - mt1.tv_sec)+(mt2.tv_nsec - mt1.tv_nsec);	// Количество времени, которое требуется для расчета на CPU
  	cout << "Time CPU: " << tt/1000000000  << " second"<< endl;		// Вывод времени для расчета на CPU
	
  	cuerr = cudaEventElapsedTime(&gpuTime, start, stop);			// расчет времени для GPU	
  	cout << "Time GPU: " << gpuTime /1000 << " second" << endl;		// Вывод времени для расчета на GPU
	cout << "Acceleration: " << tt/(gpuTime*1000000) << endl;		// Вывод ускорения
	cout << "Width: " << width << endl;					// Ширина изображения
	cout << "Height: "<< height << endl;					// Высота изображения

	for (int j = 0; j < height; j++)					// a[i + 1][j + 1]
	{
		for (int i = 0; i < width; i++)
		{	
			ebmpBYTE color = (ebmpBYTE)h_data[i * height + j];
			Input(i, j)->Red = color;
			Input(i, j)->Green = color;
			Input(i, j)->Blue = color;
		}
	}
	BMP Output;								// Создание объекта типа BMP
	Output.ReadFromFile("input.bmp"); 					// Считывает строку и заменяет любое ранее существовавшее значение для поля
		
	for (int j = 0; j < height; j++)
	{
		for (int i = 0; i < width; i++)
		{
			ebmpBYTE color = (ebmpBYTE)a[i + 1][j + 1];
			Output(i, j)->Red = color;
			Output(i, j)->Green = color;
			Output(i, j)->Blue = color;
		}
	}
	
	Input.WriteToFile("outputGPU.bmp");					// Создание выходящего файла с GPU
	Output.WriteToFile("outputCPU.bmp");					// Создание выходящего файла с CPU
	
	cudaDestroyTextureObject(texObj);					// Удаление текстуры
	cudaFreeArray(arrayInput);						// Очистка памяти (входящий массив)
	cudaFree(arrayOutput);							// Очистка памяти (выходящий массив)
	
	free(h_data);								// Очистка данных
	return 0;
}