! ------------------------------------ Pràctica 4 --------------------------------------- !
! Autor: Javier Rozalén Sarmiento
! Grup: B1B
! Data: 29/10/2019
!
! Funcionalitat: es posen a prova els mètodes d'integració de trapezis i Simpson calculant
! l'àrea escombrada per un cometa en òrbita el·líptica.

program practica3
    implicit none
    integer k
    double precision a,b,integral,inttrap,intsimps,YKohoutek
    double precision A_exacte,pi,trap_seg
    common/cts/a,b
    external YKohoutek
    10 format(e20.14,2x,e20.14,2x,e20.14) 
    a=508.633d0
    b=429.074d0
    pi=acos(-1.d0)
    A_exacte = a*b*((3.d0**1.5d0)+2.d0*pi)/24.d0

    ! -------------------------------- Apartat a) --------------------------------------- !
    open(18,file="P4-1920-b-res.dat")
    write(18,*) "# h,   A_T,    A_S"
    do k=2,20
        call trapezoids(-4.d0*a,-(7.d0/2.d0)*a,k,YKohoutek,integral)
        inttrap = integral
        call simpson(-4.d0*a,-(7.d0/2.d0)*a,k,YKohoutek,integral)
        intsimps = integral
        write(18,10) 0.5d0*a/2**k,inttrap,intsimps
    enddo

    ! -------------------------------- Apartat b) --------------------------------------- !
    open(19,file="auxb.dat")
    do k=2,20
        call trapezoids(-4.d0*a,-(7.d0/2.d0)*a,k,YKohoutek,integral)
        inttrap = integral
        call simpson(-4.d0*a,-(7.d0/2.d0)*a,k,YKohoutek,integral)
        intsimps = integral
        write(19,10) 0.5d0*a/2**k,abs(inttrap-A_exacte),abs(intsimps-A_exacte)
    enddo
    close(19)

    ! -------------------------------- Apartat c) --------------------------------------- !
    write(18,*) ""
    write(18,*) ""
    write(18,*) "# h,   A_m,    Error"
    do k=2,19
        call trapezoids(-4.d0*a,-(7.d0/2.d0)*a,k+1,YKohoutek,integral)
        trap_seg=integral
        call trapezoids(-4.d0*a,-(7.d0/2.d0)*a,k,YKohoutek,integral)
        inttrap=integral
        write(18,10) 0.5d0*a/2**k,(4.d0*trap_seg-inttrap)/3.d0,abs(((4.d0*trap_seg-inttrap)/3.d0)-A_exacte)
    enddo
    close(18)
    ! Resposta: en combinar el mètode de trapezis hàbilment s'aconsegueix una convergència 
    ! similar a la de Simpson, és a dir, com h**4. En aquest cas, per la constant de 
    ! proporcionalitat, trapezis dóna un resultat lleugerament menys errat.
end program practica3

! Subrutina trapezoids --> Calcula una integral 1-D per trapezis
subroutine trapezoids(x1,x2,k,funci,integral)
    implicit none
    double precision x1,x2,integral,h,funci
    integer N,i,k
    N = 2**k
    h = (x2-x1)/dble(N)
    integral = 0.d0
    do i=1,N-1
        integral = integral + funci(x1+i*h)
    enddo
    integral = (integral + funci(x1)/2.d0 + funci(x2)/2.d0)*h
    return
end subroutine trapezoids

! Subrutina simpson --> Calcula una integral 1-D per Simpson
subroutine simpson(x1,x2,k,funci,integral)
    implicit none
    double precision x1,x2,integral,integral1,integral2,h,funci
    integer k,N,i
    N = 2**k
    h = (x2-x1)/dble(N)
    integral1=0.d0
    integral2=0.d0
    do i=1,N-1,2
        integral1=integral1+funci(x1+i*h)
    enddo
    integral1=integral1*4.d0
    do i=2,N-2,2
        integral2=integral2+funci(x1+i*h)
    enddo
    integral2=integral2*2.d0
    integral=(integral1+integral2+funci(x1)+funci(x2))*(h/3.d0)
    return
end subroutine simpson

! Funció YKhoutek --> funció donada al principi de l'exercici
double precision function YKohoutek(x)
    implicit none
    double precision x,a,b
    common/cts/a,b
    YKohoutek = b*(1.d0-(((x+4.d0*a)**2.d0)/((a**2.d0))))**0.5d0
    return
end function YKohoutek
