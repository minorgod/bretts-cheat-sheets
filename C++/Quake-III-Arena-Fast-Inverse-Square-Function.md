# Quake III Arena's Fast Inverse Square Function

By Greg Walsh and Cleve Moler
Read the article [here](https://medium.com/hard-mode/the-legendary-fast-inverse-square-root-e51fee3b49d9) and watch the video explanation [here](https://www.youtube.com/watch?v=p8u_k2LIZyo) to see why this is such a kickass piece of code. 

```c++
float Q_rsqrt( float number )
{
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y  = number;
    i  = * ( long * ) &y;    // evil floating point bit level hacking
    i  = 0x5f3759df - ( i >> 1 );               // what the fuck? 
    y  = * ( float * ) &i;
    y  = y * ( threehalfs - ( x2 * y * y ) );   // 1st iteration
//  y  = y * ( threehalfs - ( x2 * y * y ) );   // 2nd iteration,
                                              // this can be removed

    return y;
}
```

