# HPC2022
Matmul                выполнено

VectorSum             выполнено

PI_value_calculation  выполнено

Salt and Pepper       выполнено

# Matmul:

Был написан параллельный алгоритм перемножения матриц с использованием разбиение матрицы на матрицы 16*16 и работу уже с ними + использовалась shared память. 
Алгоритм для CPU стандартный.

Язык программирования: С/С++, Python(Графики)

Для эксперимента были использованы матрицы, размерности которых кратны 32, чтобы загрузка блоков GPU была максимальной.

Использовалась видеокарта Nvidia Tesla T4.

Эксперименты проводились в Google Colab.

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

Вывод:

Если матрицы брать с размерностью более 512, то стоит использывать вычисления на GPU. При матрицах меньшей размерности разница времени вычислений незначительная.

# VectorSum(Результат):

Size : 1000 

CPU Time: 0.002889 ms

GPU Time (improved): 0.024640 ms

Acceleration factor: 0.117248 


Size : 5000 

CPU Time: 0.026103 ms

GPU Time (improved): 0.022048 ms

Acceleration factor: 1.183917 


Size : 6000 

CPU Time: 0.016935 ms

GPU Time (improved): 0.019936 ms

Acceleration factor: 0.849468 


Size : 7000 

CPU Time: 0.019786 ms

GPU Time (improved): 0.026528 ms

Acceleration factor: 0.745853 


Size : 8000 

CPU Time: 0.029911 ms

GPU Time (improved): 0.024576 ms

Acceleration factor: 1.217082 


Size : 9000 

CPU Time: 0.027104 ms

GPU Time (improved): 0.042272 ms

Acceleration factor: 0.641181 


Size : 10000 

CPU Time: 0.030123 ms

GPU Time (improved): 0.030752 ms

Acceleration factor: 0.979546 


Size : 50000 

CPU Time: 0.151009 ms

GPU Time (improved): 0.078592 ms

Acceleration factor: 1.921430 


Size : 100000 

CPU Time: 0.293632 ms

GPU Time (improved): 0.147712 ms

Acceleration factor: 1.987868 


Size : 500000 

CPU Time: 1.505501 ms

GPU Time (improved): 0.461504 ms

Acceleration factor: 3.262162 


Size : 1000000 

CPU Time: 2.965433 ms

GPU Time (improved): 0.818464 ms

Acceleration factor: 3.623168 

![изображение](https://user-images.githubusercontent.com/70959898/196279159-46550acd-577f-4d6f-8d98-c9237f8e0849.png)
![изображение](https://user-images.githubusercontent.com/70959898/196279247-4bd8ec8e-cff5-4fee-b156-749c9497d09f.png)
![изображение](https://user-images.githubusercontent.com/70959898/196279305-1591ea55-b6b6-4a61-88a2-8644318395ef.png)


# PI_value_calculation(Результат):

CPU Time

3.14134

time= 521.7 ms


GPU Time

3.14134

time = 71.5282 ms


# Salt and Pepper(Результат):

выводы по расчету изображений с размером 256х256, 512х512 и 1024х1024:

![2](https://user-images.githubusercontent.com/70959898/208243022-b2336f21-76e9-4e5d-880e-6438cc4a056a.PNG)
![5](https://user-images.githubusercontent.com/70959898/208243033-1a8aaa31-d28b-47e9-93e2-d7c043f9262f.PNG)
![Снимок](https://user-images.githubusercontent.com/70959898/208243039-662041ed-2440-42db-8616-bb43ceba6cdd.PNG)

Выходные изображения при расчете на CPU и на GPU с размером 256х256, 512х512 и 1024х1024 есть в репозитории.

Также была попытка работы с прямоугольным изображением, расчет на CPU дал свой результат, а при вычислении на GPU на картинке появляется эффект наложения. Картинки данного результата также есть в репозитории.

Время расчета и ускорение:

![изображение](https://user-images.githubusercontent.com/70959898/208243397-1533f9f9-317b-42d4-9fe7-e8e7b2fe13a4.png)

Графики результатов:

![изображение](https://user-images.githubusercontent.com/70959898/208244018-ee156ec9-80ab-4359-823d-d79358aa1b17.png)
![изображение](https://user-images.githubusercontent.com/70959898/208244277-d58a13ee-ef4e-43f9-803e-58c0197184c3.png)

Вывод: как видно из графиков, время вычисления на CPU для картинки в 1024х1024 существенно. Использование GPU на таких картинках просто необходимо, плюс расчета на GPU в том, что каждый пиксель расчитывается отдельной нитью.
