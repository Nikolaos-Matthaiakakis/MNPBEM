function [ xtab, ytab, weight ] = triangle_unit_set ( rule )

%% TRIANGLE_UNIT_SET sets a quadrature rule in a unit triangle.
%
%  Discussion:
%
%    The user is responsible for determining the value of NORDER,
%    and appropriately dimensioning the arrays XTAB, YTAB and
%    WEIGHT so that they can accommodate the data.
%
%    The value of NORDER for each rule can be found by invoking
%    the function TRIANGLE_RULE_SIZE.
%
%  Integration region:
%
%    Points (X,Y) such that
%
%      0 <= X,
%      0 <= Y, and
%      X + Y <= 1.
%
%  Graph:
%
%      ^
%    1 | *
%      | |\
%    Y | | \
%      | |  \
%    0 | *---*
%      +------->
%        0 X 1
%
%  Modified:
%
%    26 May 2004
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    H R Schwarz,
%    Methode der Finiten Elemente,
%    Teubner Studienbuecher, 1980.
%
%    Strang and Fix,
%    An Analysis of the Finite Element Method,
%    Prentice Hall, 1973, page 184.
%
%    Arthur H Stroud,
%    Approximate Calculation of Multiple Integrals,
%    Prentice Hall, 1971.
%
%    O C Zienkiewicz,
%    The Finite Element Method,
%    McGraw Hill, Third Edition, 1977, page 201.
%
%  Parameters:
%
%    Input, integer RULE, the index of the rule.
%
%     1, NORDER =  1, precision 1, Zienkiewicz #1.
%     2, NORDER =  3, precision 2, Strang and Fix formula #1.
%     3, NORDER =  3, precision 2, Strang and Fix formula #2, Zienkiewicz #2.
%     4, NORDER =  4, precision 3, Strang and Fix formula #3, Zienkiewicz #3.
%     5, NORDER =  6, precision 3, Strang and Fix formula #4.
%     6, NORDER =  6, precision 3, Stroud formula T2:3-1.
%     7, NORDER =  6, precision 4, Strang and Fix formula #5.
%     8, NORDER =  7, precision 4, Strang and Fix formula #6.
%     9, NORDER =  7, precision 5, Strang and Fix formula #7,
%        Stroud formula T2:5-1, Zienkiewicz #4, Schwarz Table 2.2.
%    10, NORDER =  9, precision 6, Strang and Fix formula #8.
%    11, NORDER = 12, precision 6, Strang and Fix formula #9.
%    12, NORDER = 13, precision 7, Strang and Fix formula #10.
%    13, NORDER =  7, precision ?.
%    14, NORDER = 16, precision 7, conical product Gauss, Stroud formula T2:7-1.
%    15, NORDER = 64, precision 15, triangular product Gauss rule.
%    16, NORDER = 19, precision 8, from CUBTRI, ACM TOMS #584.
%    17, NORDER = 19, precision 9, from TRIEX, Lyness and Jespersen.
%    18, NORDER = 28, precision 11, from TRIEX, Lyness and Jespersen.
%    19, NORDER = 37, precision 13, from ACM TOMS #706.
%
%    Output, double precision XTAB(NORDER), YTAB(NORDER), the abscissas.
%
%    Output, double precision WEIGHT(NORDER), the weights of the rule.
%

%
%  1 point, precision 1.
%
  if ( rule == 1 )

    a = 1.0E+00 / 3.0E+00;
    w = 1.0E+00;

    xtab(1) = a;
    ytab(1) = a;
    weight(1) = w;
%
%  3 points, precision 2, Strang and Fix formula #1.
%
  elseif ( rule == 2 )

    a = 1.0E+00;
    b = 3.0E+00;
    c = 4.0E+00;
    d = 6.0E+00;

    xtab(1:3) =   [ c, a, a ] / d;
    ytab(1:3) =   [ a, c, a ] / d;
    weight(1:3) = [ a, a, a ] / b;
%
%  3 points, precision 2, Strang and Fix formula #2.
%
  elseif ( rule == 3 )

    a = 0.5E+00;
    b = 1.0E+00;
    c = 1.0E+00 / 3.0E+00;
    z = 0.0E+00;

    xtab(1:3) =   [ z, a, a ];
    ytab(1:3) =   [ a, z, a ];
    weight(1:3) = [ c, c, c ];
%
%  4 points, precision 3, Strang and Fix formula #3.
%
  elseif ( rule == 4 )

    a =   6.0E+00;
    b =  10.0E+00;
    c =  18.0E+00;
    d =  25.0E+00;
    e = -27.0E+00;
    f =  30.0E+00;
    g =  48.0E+00;

    xtab(1:4) =   [ b, c, a, a ] / f;
    ytab(1:4) =   [ b, a, c, a ] / f;
    weight(1:4) = [ e, d, d, d ] / g;
%
%  6 points, precision 3, Strang and Fix formula #4.
%
  elseif ( rule == 5 )

    a = 0.659027622374092E+00;
    b = 0.231933368553031E+00;
    c = 0.109039009072877E+00;
    w = 1.0E+00 / 6.0E+00;

    xtab(1:6) =   [ a, a, b, b, c, c ];
    ytab(1:6) =   [ b, c, a, c, a, b ];
    weight(1:6) = [ w, w, w, w, w, w ];
%
%  6 points, precision 3, Stroud T2:3-1.
%
  elseif ( rule == 6 )

    a = 0.0E+00;
    b = 0.5E+00;
    c = 2.0E+00 /  3.0E+00;
    d = 1.0E+00 /  6.0E+00;
    v = 1.0E+00 / 30.0E+00;
    w = 3.0E+00 / 10.0E+00;

    xtab(1:6) =   [ a, b, b, c, d, d ];
    ytab(1:6) =   [ b, a, b, d, c, d ];
    weight(1:6) = [ v, v, v, w, w, w ];
%
%  6 points, precision 4, Strang and Fix, formula #5.
%
  elseif ( rule == 7 )

    a = 0.816847572980459E+00;
    b = 0.091576213509771E+00;
    c = 0.108103018168070E+00;
    d = 0.445948490915965E+00;
    v = 0.109951743655322E+00;
    w = 0.223381589678011E+00;

    xtab(1:6) =   [ a, b, b, c, d, d ];
    ytab(1:6) =   [ b, a, b, d, c, d ];
    weight(1:6) = [ v, v, v, w, w, w ];
%
%  7 points, precision 4, Strang and Fix formula #6.
%
  elseif ( rule == 8 )

    a = 1.0E+00 / 3.0E+00;
    c = 0.736712498968435E+00;
    d = 0.237932366472434E+00;
    e = 0.025355134551932E+00;
    v = 0.375E+00;
    w = 0.104166666666667E+00;

    xtab(1:7) =   [ a, c, c, d, d, e, e ];
    ytab(1:7) =   [ a, d, e, c, e, c, d ];
    weight(1:7) = [ v, w, w, w, w, w, w ];
%
%  7 points, precision 5, Strang and Fix formula #7, Stroud T2:5-1
%
  elseif ( rule == 9 )

    a = 1.0E+00 / 3.0E+00;
    b = ( 9.0E+00 + 2.0E+00 * sqrt ( 15.0E+00 ) ) / 21.0E+00;
    c = ( 6.0E+00 -           sqrt ( 15.0E+00 ) ) / 21.0E+00;
    d = ( 9.0E+00 - 2.0E+00 * sqrt ( 15.0E+00 ) ) / 21.0E+00;
    e = ( 6.0E+00 +           sqrt ( 15.0E+00 ) ) / 21.0E+00;
    u = 0.225E+00;
    v = ( 155.0E+00 - sqrt ( 15.0E+00 ) ) / 1200.0E+00;
    w = ( 155.0E+00 + sqrt ( 15.0E+00 ) ) / 1200.0E+00;

    xtab(1:7) =   [ a, b, c, c, d, e, e ];
    ytab(1:7) =   [ a, c, b, c, e, d, e ];
    weight(1:7) = [ u, v, v, v, w, w, w ];
%
%  9 points, precision 6, Strang and Fix formula #8.
%
  elseif ( rule == 10 )

    a = 0.124949503233232E+00;
    b = 0.437525248383384E+00;
    c = 0.797112651860071E+00;
    d = 0.165409927389841E+00;
    e = 0.037477420750088E+00;

    u = 0.205950504760887E+00;
    v = 0.063691414286223E+00;

    xtab(1:9) =   [ a, b, b, c, c, d, d, e, e ];
    ytab(1:9) =   [ b, a, b, d, e, c, e, c, d ];
    weight(1:9) = [ u, u, u, v, v, v, v, v, v ];
%
%  12 points, precision 6, Strang and Fix, formula #9.
%
  elseif ( rule == 11 )

    a = 0.873821971016996E+00;
    b = 0.063089014491502E+00;
    c = 0.501426509658179E+00;
    d = 0.249286745170910E+00;
    e = 0.636502499121399E+00;
    f = 0.310352451033785E+00;
    g = 0.053145049844816E+00;

    u = 0.050844906370207E+00;
    v = 0.116786275726379E+00;
    w = 0.082851075618374E+00;

    xtab(1:12) =   [ a, b, b, d, c, d, e, e, f, f, g, g ];
    ytab(1:12) =   [ b, a, b, c, d, d, f, g, e, g, e, f ];
    weight(1:12) = [ u, u, u, v, v, v, w, w, w, w, w, w ];
%
%  13 points, precision 7, Strang and Fix, formula #10.
%
  elseif ( rule == 12 )

    a = 0.479308067841923E+00;
    b = 0.260345966079038E+00;
    c = 0.869739794195568E+00;
    d = 0.065130102902216E+00;
    e = 0.638444188569809E+00;
    f = 0.312865496004875E+00;
    g = 0.048690315425316E+00;
    h = 1.0E+00 / 3.0E+00;
    t = 0.175615257433204E+00;
    u = 0.053347235608839E+00;
    v = 0.077113760890257E+00;
    w = -0.149570044467670E+00;

    xtab(1:13) =   [ a, b, b, c, d, d, e, e, f, f, g, g, h ];
    ytab(1:13) =   [ b, a, b, d, c, d, f, g, e, g, e, f, h ];
    weight(1:13) = [ t, t, t, u, u, u, v, v, v, v, v, v, w ];
%
%  7 points, precision ?.
%
  elseif ( rule == 13 )

    a = 1.0E+00 / 3.0E+00;
    b = 1.0E+00;
    c = 0.5E+00;
    z = 0.0E+00;

    u = 27.0E+00 / 60.0E+00;
    v =  3.0E+00 / 60.0E+00;
    w =  8.0E+00 / 60.0E+00;

    xtab(1:7) =   [ a, b, z, z, z, c, c ];
    ytab(1:7) =   [ a, z, b, z, c, z, c ];
    weight(1:7) = [ u, v, v, v, w, w, w ];
%
%  16 points.
%
  elseif ( rule == 14 )
%
%  Legendre rule of order 4.
%
    norder2 = 4;

    xtab1(1) = - 0.861136311594052575223946488893E+00;
    xtab1(2) = - 0.339981043584856264802665759103E+00;
    xtab1(3) =   0.339981043584856264802665759103E+00;
    xtab1(4) =   0.861136311594052575223946488893E+00;

    weight1(1) = 0.347854845137453857373063949222E+00;
    weight1(2) = 0.652145154862546142626936050778E+00;
    weight1(3) = 0.652145154862546142626936050778E+00;
    weight1(4) = 0.347854845137453857373063949222E+00;

    xtab1(1:norder2) = 0.5E+00 * ( xtab1(1:norder2) + 1.0E+00 );

    weight2(1) = 0.1355069134E+00;
    weight2(2) = 0.2034645680E+00;
    weight2(3) = 0.1298475476E+00;
    weight2(4) = 0.0311809709E+00;

    xtab2(1) = 0.0571041961E+00;
    xtab2(2) = 0.2768430136E+00;
    xtab2(3) = 0.5835904324E+00;
    xtab2(4) = 0.8602401357E+00;

    k = 0;
    for i = 1 : norder2
      for j = 1 : norder2
        k = k + 1;
        xtab(k) = xtab2(j);
        ytab(k) = xtab1(i) * ( 1.0E+00 - xtab2(j) );
        weight(k) = weight1(i) * weight2(j);
      end
    end
%
%  64 points, precision 15.
%
  elseif ( rule == 15 )
%
%  Legendre rule of order 8.
%
    norder2 = 8;

    xtab1(1) = - 0.960289856497536231683560868569E+00;
    xtab1(2) = - 0.796666477413626739591553936476E+00;
    xtab1(3) = - 0.525532409916328985817739049189E+00;
    xtab1(4) = - 0.183434642495649804939476142360E+00;
    xtab1(5) =   0.183434642495649804939476142360E+00;
    xtab1(6) =   0.525532409916328985817739049189E+00;
    xtab1(7) =   0.796666477413626739591553936476E+00;
    xtab1(8) =   0.960289856497536231683560868569E+00;

    weight1(1) = 0.101228536290376259152531354310E+00;
    weight1(2) = 0.222381034453374470544355994426E+00;
    weight1(3) = 0.313706645877887287337962201987E+00;
    weight1(4) = 0.362683783378361982965150449277E+00;
    weight1(5) = 0.362683783378361982965150449277E+00;
    weight1(6) = 0.313706645877887287337962201987E+00;
    weight1(7) = 0.222381034453374470544355994426E+00;
    weight1(8) = 0.101228536290376259152531354310E+00;

    weight2(1) = 0.00329519144E+00;
    weight2(2) = 0.01784290266E+00;
    weight2(3) = 0.04543931950E+00;
    weight2(4) = 0.07919959949E+00;
    weight2(5) = 0.10604735944E+00;
    weight2(6) = 0.11250579947E+00;
    weight2(7) = 0.09111902364E+00;
    weight2(8) = 0.04455080436E+00;

    xtab2(1) = 0.04463395529E+00;
    xtab2(2) = 0.14436625704E+00;
    xtab2(3) = 0.28682475714E+00;
    xtab2(4) = 0.45481331520E+00;
    xtab2(5) = 0.62806783542E+00;
    xtab2(6) = 0.78569152060E+00;
    xtab2(7) = 0.90867639210E+00;
    xtab2(8) = 0.98222008485E+00;

    k = 0;
    for j = 1 : norder2
      for i = 1 : norder2
        k = k + 1;
        xtab(k) = 1.0E+00 - xtab2(j);
        ytab(k) = 0.5E+00 * ( 1.0E+00 + xtab1(i) ) * xtab2(j);
        weight(k) = weight1(i) * weight2(j);
      end
    end
%
%  19 points, precision 8.
%
  elseif ( rule == 16 )

    a = 1.0E+00 / 3.0E+00;
    b = ( 9.0E+00 + 2.0E+00 * sqrt ( 15.0E+00 ) ) / 21.0E+00;
    c = ( 6.0E+00 -       sqrt ( 15.0E+00 ) ) / 21.0E+00;
    d = ( 9.0E+00 - 2.0E+00 * sqrt ( 15.0E+00 ) ) / 21.0E+00;
    e = ( 6.0E+00 +       sqrt ( 15.0E+00 ) ) / 21.0E+00;
    f = ( 40.0E+00 - 10.0E+00 * sqrt ( 15.0E+00 ) ...
      + 10.0E+00 * sqrt ( 7.0E+00 ) + 2.0E+00 * sqrt ( 105.0E+00 ) ) / 90.0E+00;
    g = ( 25.0E+00 +  5.0E+00 * sqrt ( 15.0E+00 ) ...
      -  5.0E+00 * sqrt ( 7.0E+00 ) - sqrt ( 105.0E+00 ) ) / 90.0E+00;
    p = ( 40.0E+00 + 10.0E+00 * sqrt ( 15.0E+00 ) ...
      + 10.0E+00 * sqrt ( 7.0E+00 ) - 2.0E+00 * sqrt ( 105.0E+00 ) ) / 90.0E+00;
    q = ( 25.0E+00 -  5.0E+00 * sqrt ( 15.0E+00 ) ...
      -  5.0E+00 * sqrt ( 7.0E+00 ) + sqrt ( 105.0E+00 ) ) / 90.0E+00;
    r = ( 40.0E+00 + 10.0E+00 * sqrt ( 7.0E+00 ) ) / 90.0E+00;
    s = ( 25.0E+00 +  5.0E+00 * sqrt ( 15.0E+00 ) - 5.0E+00 * sqrt ( 7.0E+00 ) ...
      - sqrt ( 105.0E+00 ) ) / 90.0E+00;
    t = ( 25.0E+00 -  5.0E+00 * sqrt ( 15.0E+00 ) - 5.0E+00 * sqrt ( 7.0E+00 ) ...
      + sqrt ( 105.0E+00 ) ) / 90.0E+00;

    w1 = ( 7137.0E+00 - 1800.0E+00 * sqrt ( 7.0E+00 ) ) / 62720.0E+00;
    w2 = - 9301697.0E+00 / 4695040.0E+00 - 13517313.0E+00 * sqrt ( 15.0E+00 ) ...
      / 23475200.0E+00 + 764885.0E+00 * sqrt ( 7.0E+00 ) / 939008.0E+00 ...
      + 198763.0E+00 * sqrt ( 105.0E+00 ) / 939008.0E+00;
    w2 = w2 / 3.0E+00;
    w3 = -9301697.0E+00 / 4695040.0E+00 + 13517313.0E+00 * sqrt ( 15.0E+00 ) ...
      / 23475200.0E+00 ...
      + 764885.0E+00 * sqrt ( 7.0E+00 ) / 939008.0E+00 ...
      - 198763.0E+00 * sqrt ( 105.0E+00 ) / 939008.0E+00;
    w3 = w3 / 3.0E+00;
    w4 = ( 102791225.0E+00 - 23876225.0E+00 * sqrt ( 15.0E+00 ) ...
      - 34500875.0E+00 * sqrt ( 7.0E+00 ) ...
      + 9914825.0E+00 * sqrt ( 105.0E+00 ) ) / 59157504.0E+00;
    w4 = w4 / 3.0E+00;
    w5 = ( 102791225.0E+00 + 23876225.0E+00 * sqrt ( 15.0E+00 ) ...
      - 34500875.0E+00 * sqrt ( 7.0E+00 ) ...
      - 9914825E+00 * sqrt ( 105.0E+00 ) ) / 59157504.0E+00;
    w5 = w5 / 3.0E+00;
    w6 = ( 11075.0E+00 - 3500.0E+00 * sqrt ( 7.0E+00 ) ) / 8064.0E+00;
    w6 = w6 / 6.0E+00;

    xtab(1:19) =   [  a,  b,  c,  c,  d,  e,  e,  f,  g,  g,  p,  q,  q, ...
      r,  r,  s,  s,  t,  t ];
    ytab(1:19) =   [  a,  c,  b,  c,  e,  d,  e,  g,  f,  g,  q,  p,  q, ...
      s,  t,  r,  t,  r,  s ];
    weight(1:19) = [ w1, w2, w2, w2, w3, w3, w3, w4, w4, w4, w5, w5, w5, ...
      w6, w6, w6, w6, w6, w6 ];
%
%  19 points, precision 9.
%
  elseif ( rule == 17 )

    a = 1.0E+00 / 3.0E+00;
    b = 0.02063496160252593E+00;
    c = 0.4896825191987370E+00;
    d = 0.1258208170141290E+00;
    e = 0.4370895914929355E+00;
    f = 0.6235929287619356E+00;
    g = 0.1882035356190322E+00;
    r = 0.9105409732110941E+00;
    s = 0.04472951339445297E+00;
    t = 0.7411985987844980E+00;
    u = 0.03683841205473626E+00;
    v = 0.22196288916076574E+00;

    w1 = 0.09713579628279610E+00;
    w2 = 0.03133470022713983E+00;
    w3 = 0.07782754100477543E+00;
    w4 = 0.07964773892720910E+00;
    w5 = 0.02557767565869810E+00;
    w6 = 0.04328353937728940E+00;

    xtab(1:19) =   [  a,  b,  c,  c,  d,  e,  e,  f,  g,  g,  r,  s,  s, ...
      t, t, u, u, v, v ];
    ytab(1:19) =   [  a,  c,  b,  c,  e,  d,  e,  g,  f,  g,  s,  r,  s, ...
      u, v, t, v, t, u ];
    weight(1:19) = [ w1, w2, w2, w2, w3, w3, w3, w4, w4, w4, w5, w5, w5, ...
      w6, w6, w6, w6, w6, w6 ];
%
%  28 points, precision 11.
%
  elseif ( rule == 18 )

    a = 1.0E+00 / 3.0E+00;
    b = 0.9480217181434233E+00;
    c = 0.02598914092828833E+00;
    d = 0.8114249947041546E+00;
    e = 0.09428750264792270E+00;
    f = 0.01072644996557060E+00;
    g = 0.4946367750172147E+00;
    p = 0.5853132347709715E+00;
    q = 0.2073433826145142E+00;
    r = 0.1221843885990187E+00;
    s = 0.4389078057004907E+00;
    t = 0.6779376548825902E+00;
    u = 0.04484167758913055E+00;
    v = 0.27722066752827925E+00;
    w = 0.8588702812826364E+00;
    x = 0.0E+00;
    y = 0.1411297187173636E+00;

    w1 = 0.08797730116222190E+00;
    w2 = 0.008744311553736190E+00;
    w3 = 0.03808157199393533E+00;
    w4 = 0.01885544805613125E+00;
    w5 = 0.07215969754474100E+00;
    w6 = 0.06932913870553720E+00;
    w7 = 0.04105631542928860E+00;
    w8 = 0.007362383783300573E+00;

    xtab(1:28) =   [  a,  b,  c,  c,  d,  e,  e,  f,  g,  g,  p,  q,  q, ...
       r,  s,  s,  t,  t,  u,  u,  v,  v,  w,  w,  x,  x,  y,  y ];
    ytab(1:28) =   [  a,  c,  b,  c,  e,  d,  e,  g,  f,  g,  q,  p,  q, ...
       s,  r,  s,  u,  v,  t,  v,  t,  u,  x,  y,  w,  y,  w,  x ];
    weight(1:28) = [ w1, w2, w2, w2, w3, w3, w3, w4, w4, w4, w5, w5, w5, ...
      w6, w6, w6, w7, w7, w7, w7, w7, w7, w8, w8, w8, w8, w8, w8 ];
%
%  37 points, precision 13.
%
  elseif ( rule == 19 )

    a = 1.0E+00 / 3.0E+00;
    b = 0.950275662924105565450352089520E+00;
    c = 0.024862168537947217274823955239E+00;
    d = 0.171614914923835347556304795551E+00;
    e = 0.414192542538082326221847602214E+00;
    f = 0.539412243677190440263092985511E+00;
    g = 0.230293878161404779868453507244E+00;

    w1 = 0.051739766065744133555179145422E+00;
    w2 = 0.008007799555564801597804123460E+00;
    w3 = 0.046868898981821644823226732071E+00;
    w4 = 0.046590940183976487960361770070E+00;
    w5 = 0.031016943313796381407646220131E+00;
    w6 = 0.010791612736631273623178240136E+00;
    w7 = 0.032195534242431618819414482205E+00;
    w8 = 0.015445834210701583817692900053E+00;
    w9 = 0.017822989923178661888748319485E+00;
    wx = 0.037038683681384627918546472190E+00;

    xtab(1:10) =   [ a, b, c, c, d, e, e, f, g, g ];
    ytab(1:10) =   [ a, c, b, c, e, d, e, g, f, g ];
    weight(1:37) = [ w1, w2, w2, w2, w3, w3, w3, w4, w4, w4, w5, w5, w5, ...
      w6, w6, w6, w7, w7, w7, w8, w8, w8, w8, w8, w8, w9, ...
      w9, w9, w9, w9, w9, wx, wx, wx, wx, wx, wx ];

    a = 0.772160036676532561750285570113E+00;
    b = 0.113919981661733719124857214943E+00;

    xtab(11) = a;
    ytab(11) = b;

    xtab(12) = b;
    ytab(12) = a;

    xtab(13) = b;
    ytab(13) = b;

    a = 0.009085399949835353883572964740E+00;
    b = 0.495457300025082323058213517632E+00;

    xtab(14) = a;
    ytab(14) = b;

    xtab(15) = b;
    ytab(15) = a;

    xtab(16) = b;
    ytab(16) = b;

    a = 0.062277290305886993497083640527E+00;
    b = 0.468861354847056503251458179727E+00;

    xtab(17) = a;
    ytab(17) = b;

    xtab(18) = b;
    ytab(18) = a;

    xtab(19) = b;
    ytab(19) = b;

    a = 0.022076289653624405142446876931E+00;
    b = 0.851306504174348550389457672223E+00;
    c = 1.0E+00 - a - b;

    xtab(20) = a;
    ytab(20) = b;

    xtab(21) = a;
    ytab(21) = c;

    xtab(22) = b;
    ytab(22) = a;

    xtab(23) = b;
    ytab(23) = c;

    xtab(24) = c;
    ytab(24) = a;

    xtab(25) = c;
    ytab(25) = b;

    a = 0.018620522802520968955913511549E+00;
    b = 0.689441970728591295496647976487E+00;
    c = 1.0E+00 - a - b;

    xtab(26) = a;
    ytab(26) = b;

    xtab(27) = a;
    ytab(27) = c;

    xtab(28) = b;
    ytab(28) = a;

    xtab(29) = b;
    ytab(29) = c;

    xtab(30) = c;
    ytab(30) = a;

    xtab(31) = c;
    ytab(31) = b;

    a = 0.096506481292159228736516560903E+00;
    b = 0.635867859433872768286976979827E+00;
    c = 1.0E+00 - a - b;

    xtab(32) = a;
    ytab(32) = b;

    xtab(33) = a;
    ytab(33) = c;

    xtab(34) = b;
    ytab(34) = a;

    xtab(35) = b;
    ytab(35) = c;

    xtab(36) = c;
    ytab(36) = a;

    xtab(37) = c;
    ytab(37) = b;

  else

    fprintf ( 1, '\n' );
    fprintf ( 1, 'TRIANGLE_UNIT_SET - Fatal error!\n' );
    fprintf ( 1, '  Illegal value of RULE = %d\n', rule );
    error ( 'TRIANGLE_UNIT_SET - Fatal error!' );

  end
