# HPC2022
Matmul          +

VectorSum       -

PI calc         -

Salt and Pepper -

Был написан параллельный алгоритм перемножения матриц с использованием разбиение матрицы на матрицы 16*16 и работу уже с ними + использовалась shared память. 
Алгоритм для CPU стандартный.

Язык программирования: С/С++

Для эксперимента были использованы матрицы, размерности которых кратны 32, чтобы загрузка блоков GPU была максимальной.

Использовалась видеокарта Nvidia Tesla T4.

Экспементы проводились в Google Colab.

Результат:

Experiment for matrix size: 64 

Time spent executing by the CPU: 1154.00 millseconds

Time spent executing by the GPU events: 0.06 millseconds

Time spent executing by the GPU: 271.00 millseconds

Acceleration factor: 4.26 

Relevance: true 


Experiment for matrix size: 128 

Time spent executing by the CPU: 9917.00 millseconds

Time spent executing by the GPU events: 0.12 millseconds

Time spent executing by the GPU: 329.00 millseconds

Acceleration factor: 30.14 

Relevance: true 


Experiment for matrix size: 256 

Time spent executing by the CPU: 82266.00 millseconds

Time spent executing by the GPU events: 0.39 millseconds

Time spent executing by the GPU: 688.00 millseconds

Acceleration factor: 119.57 

Relevance: true 


Experiment for matrix size: 512 

Time spent executing by the CPU: 828156.00 millseconds

Time spent executing by the GPU events: 1.75 millseconds

Time spent executing by the GPU: 2349.00 millseconds

Acceleration factor: 352.56 

Relevance: true 


Experiment for matrix size: 1024 

Time spent executing by the CPU: 11066140.00 millseconds

Time spent executing by the GPU events: 10.64 millseconds

Time spent executing by the GPU: 11686.00 millseconds

Acceleration factor: 946.96 

Relevance: true 



Experiment for matrix size: 2048 

Time spent executing by the CPU: 134362099.00 millseconds

Time spent executing by the GPU events: 64.86 millseconds

Time spent executing by the GPU: 67237.00 millseconds

Acceleration factor: 1998.34 

Relevance: true 


Графики результатов:

![изображение](https://user-images.githubusercontent.com/70959898/195664279-ec089d12-e342-4e96-81e6-6d41a845ec89.png)
![изображение](https://user-images.githubusercontent.com/70959898/195664351-056a13a6-c1b5-453a-9d9d-6fa90f74ed75.png)

