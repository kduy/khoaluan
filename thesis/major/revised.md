# Chapter 1 : Introduction


# Chapter 2: Data Stream Model
###Order
- singple model vs. distributed model
- partial order
- total order : strict
- Temporal order: 
- Positional order: // TODO : give example

###Time
- Time domain: 
- Application timestamp
- System timestamp
- app vs. sys timestamp 

###Tuple

## 2.1 Stream Model
- definition in CQL
- stream definition in other systems
- in  Flink: //TODO: tsys is required, tapp is optional
// TODO: in Flink EXECUTION model

- //TODO: Data Stream Properties
    + sequence of record, order by time 
    + from variety of external sources
    + continously
    + high speed

- Stream Representation
    + Base stream vs. derived stream 
    + Logical vs. Physical stream // TODO

## 2.2 Stream Windows
- why do we need windows
- // TODO: Approximate Query Answering: (Models and issues in data stream systems)
- window definition: regardless of window constructions
- window specification
- Window Classification
    + Direction of movement
        * Fixed Window
        * Landmark window
        * Sliding window
        * Tumbling window
        * jumping window
    + Contents
        * time-based window
        * count-based window
        * Delta-based window
        * Partitioned Window
        * Predicate window

# Chapter 3: The execution semantic of Stream Processing in Flink

## 3.1 Heterogeneity
- Syntax
- Capability Heterogeneity
- Execution Model
    + time-driven
    + tuple-driven
    + batch-driven: coral8 : atomic bundles?, its advantages
    + // TODO: Spark D-Stream
    + 
http://arxiv.org/pdf/1503.01143.pdf

## 3.2 Policy-based Window Semantics


## 3.3 The execution models in Flink


# Chapter 4: FlinkCQL - Queries over Data Stream

## 4.1 Fundamental Features



## 4.2 Continous Query Language

## 4.3 Continous Query Semantics and Operators


# Chapter 5: Implementation

## 5.1 Overral Architecture

## 5.2 Evaluation

## 5.3 Future Works



----------
// TODO:
-Done: why do we need window?
- Done: Spark?
-Done: lower boundary
- partitioned in window
- chapter 4:
    + last part


------------

- Explicit timestamps have the drawback that tuples may not arrive in the same order as their timestamps - tuples with later timestamp may come before tuple withe earlier timestamps. this lack of guaranteed ordering make it difficult to perform sliding window computations that are defined in relation to explicit timestamp or any other processing based on order.   [4] Models and issues
=> delay 


- Why need window : [4] page 8, 14






------

\begin{table}[h]
\caption{Data Type}
\centering
\label{table:Data Type}
\setlength\extrarowheight{5pt}
\renewcommand{\arraystretch}{1.5}
\begin{tabular}{>{\centering\bfseries}m{1in} >{\centering}m{1in} >{\centering}m{1in} >{\centering\arraybackslash}m{1in}}
\hline
%\rowcolor[HTML]{ECF4FF} 
%{\color[HTML]{ECF4FF} \textbf{Scala Type}} & {\color[HTML]{ECF4FF} \textbf{Flink Type}} & {\color[HTML]{ECF4FF} \textbf{Viewable as}} \\ \hline
\textbf{FlinkCQL Type} & \textbf{Description} & \textbf{Flink Type} & \textbf{Convertable to} \\ \hline\hline
                    String  & A sequence of Chars             &           STRING\_TYPE\_INFO                   &  \\ \hline
                    Boolean & Either the literal true or the literal false          &           BOOLEAN\_TYPE\_INFO                  &   \\ \hline
                   Char     & 16 bit unsigned Unicode character. Range from U+0000 to U+FFFF            &           CHAR\_TYPE\_INFO                       &  Byte, Short, Integer, Long, Double\\ \hline
                    Byte         & 8 bit signed value. Range from -128 to 127           &           BYTE\_TYPE\_INFO                     & Short, Integer, Long,Float, Double \\ \hline
                    Short   & 16 bit signed value. Range -32768 to 32767            &           SHORT\_TYPE\_INFO                    & Integer, Long, Float, Double\\ \hline                                
                    Int     & 32 bit signed value. Range -2147483648 to 2147483647          &           INT\_TYPE\_INFO                      & Long, Float, Double\\ \hline
                    Long        & 64 bit signed value. -9223372036854775808 to 9223372036854775807          &           LONG\_TYPE\_INFO                     & Float, Double \\ \hline                              
                    Float   & 32 bit IEEE 754 single-precision float            &           FLOAT\_TYPE\_INFO                    & Double \\ \hline
                    Double  & 64 bit IEEE 754 double-precision float            &           DOUBLE\_TYPE\_INFO                   &   \\ \hline                          
    Datetime                &    &       DATE\_TYPE\_INFO                &          \\ \hline                                                                                                                                                              
\end{tabular}
\end{table}

