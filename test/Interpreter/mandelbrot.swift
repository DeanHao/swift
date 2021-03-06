// RUN: %target-jit-run -I %S -enable-source-import %s | FileCheck %s
// REQUIRES: executable_test
// REQUIRES: swift_interpreter

// FIXME: iOS: -enable-source-import plus %target-build-swift equals link errors
// FIXME: This test uses IRGen with -enable-source-import; it may fail with -g.

import complex

func printDensity(_ d: Int) {
  if (d > 40) {
     print(" ", terminator: "")
  } else if d > 6 {
     print(".", terminator: "")
  } else if d > 4 {
     print("+", terminator: "")
  } else if d > 2 {
     print("*", terminator: "")
  } else {
     print("#", terminator: "")
  }
}

func getMandelbrotIterations(_ c: Complex, _ maxIterations: Int) -> Int {
  var n = 0
  var z = Complex() 
  while (n < maxIterations && z.magnitude() < 4.0) {
    z = z*z + c
    n += 1
  }
  return n
}

func mandelbrot(_ xMin: Double, _ xMax: Double,
                _ yMin: Double, _ yMax: Double,
                _ rows: Int, _ cols: Int) {
  // Set the spacing for the points in the Mandelbrot set.
  var dX = (xMax - xMin) / Double(rows)
  var dY = (yMax - yMin) / Double(cols)
  // Iterate over the points an determine if they are in the
  // Mandelbrot set.
  for row in stride(from: xMin, to: xMax, by: dX) {
    for col in stride(from: yMin, to: yMax, by: dY) {
      var c = Complex(real: col, imag: row)
      printDensity(getMandelbrotIterations(c, 200))
    }
    print("\n", terminator: "")
  }
}

mandelbrot(-1.35, 1.4, -2.0, 1.05, 40, 80)

// CHECK: ################################################################################
// CHECK: ##############################********************##############################
// CHECK: ########################********************************########################
// CHECK: ####################***************************+++**********####################
// CHECK: #################****************************++...+++**********#################
// CHECK: ##############*****************************++++......+************##############
// CHECK: ############******************************++++.......+++************############
// CHECK: ##########******************************+++++....  ...++++************##########
// CHECK: ########******************************+++++....      ..++++++**********#########
// CHECK: #######****************************+++++.......     .....++++++**********#######
// CHECK: ######*************************+++++....... . ..   ............++*********######
// CHECK: #####*********************+++++++++...   ..             . ... ..++*********#####
// CHECK: ####******************++++++++++++.....                       ..++**********####
// CHECK: ###***************++++++++++++++... .                        ...+++**********###
// CHECK: ##**************+++.................                          ....+***********##
// CHECK: ##***********+++++.................                             .++***********##
// CHECK: #**********++++++.....       .....                             ..++***********##
// CHECK: #*********++++++......          .                              ..++************#
// CHECK: #*******+++++.......                                          ..+++************#
// CHECK: #++++............                                            ...+++************#
// CHECK: #++++............                                            ...+++************#
// CHECK: #******+++++........                                          ..+++************#
// CHECK: #********++++++.....            .                              ..++************#
// CHECK: #**********++++++.....        ....                              .++************#
// CHECK: #************+++++.................                            ..++***********##
// CHECK: ##*************++++.................                          . ..+***********##
// CHECK: ###***************+.+++++++++++.....                         ....++**********###
// CHECK: ###******************+++++++++++++.....                      ...+++*********####
// CHECK: ####*********************++++++++++....                   ..  ..++*********#####
// CHECK: #####*************************+++++........ . .        . .......+*********######
// CHECK: #######***************************+++..........     .....+++++++*********#######
// CHECK: ########*****************************++++++....      ...++++++**********########
// CHECK: ##########*****************************+++++.....  ....++++***********##########
// CHECK: ###########******************************+++++........+++***********############
// CHECK: #############******************************++++.. ...++***********##############
// CHECK: ################****************************+++...+++***********################
// CHECK: ###################***************************+.+++**********###################
// CHECK: #######################**********************************#######################
// CHECK: ############################************************############################
// CHECK: ################################################################################
