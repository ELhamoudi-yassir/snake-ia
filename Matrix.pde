
class Matrix {
  
  //variables locale
  int rows;
  int cols;
  float[][] matrix;
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //constructor
  Matrix(int r, int c) {
    rows = r;
    cols = c;
    matrix = new float[rows][cols];
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //constructor de 2D array
  Matrix(float[][] m) {
    matrix = m;
    cols = m.length;
    rows = m[0].length;
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //taper matrice
  void output() {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        print(matrix[i][j] + "  ");
      }
      println(" ");
    }
    println();
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  
  //multiplier par N
  void multiply(float n ) {

    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] *= n;
      }
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //return une matrice  qui produit le parametre matrix
  Matrix dot(Matrix n) {
    Matrix result = new Matrix(rows, n.cols);
   
    if (cols == n.rows) {
      //pour chaque spot dans la nouvelle matrix
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<n.cols; j++) {
          float sum = 0;
          for (int k = 0; k<cols; k++) {
            sum+= matrix[i][k]*n.matrix[k][j];
          }
          result.matrix[i][j] = sum;
        }
      }
    }

    return result;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //initialiser aleatoire entre -1 et 1
  void randomize() {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] = random(-1, 1);
      }
    }
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //Ajouter scalere 
  void Add(float n ) {
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        matrix[i][j] += n;
      }
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  ///return une matrice qui produit la matrix +le parametre matrix
  Matrix add(Matrix n ) {
    Matrix newMatrix = new Matrix(rows, cols);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] + n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  ///return une matrice qui produit la matrix - le parametre matrix
  Matrix subtract(Matrix n ) {
    Matrix newMatrix = new Matrix(cols, rows);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] - n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //  ///return une matrice qui produit la matrice * le parametre matrix
  Matrix multiply(Matrix n ) {
    Matrix newMatrix = new Matrix(rows, cols);
    if (cols == n.cols && rows == n.rows) {
      for (int i =0; i<rows; i++) {
        for (int j = 0; j<cols; j++) {
          newMatrix.matrix[i][j] = matrix[i][j] * n.matrix[i][j];
        }
      }
    }
    return newMatrix;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //retourner une matrice qui est le transposer de cette matrice
  Matrix transpose() {
    Matrix n = new Matrix(cols, rows);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[j][i] = matrix[i][j];
      }
    }
    return n;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //crer un colonne array de le parametre arrray
  Matrix singleColumnMatrixFromArray(float[] arr) {
    Matrix n = new Matrix(arr.length, 1);
    for (int i = 0; i< arr.length; i++) {
      n.matrix[i][0] = arr[i];
    }
    return n;
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //renitialiser la matrice dapartir array
  void fromArray(float[] arr) {
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        matrix[i][j] =  arr[j+i*cols];
      }
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------    
  //retourner un tableau qui presente la matrice
  float[] toArray() {
    float[] arr = new float[rows*cols];
    for (int i = 0; i< rows; i++) {
      for (int j = 0; j< cols; j++) {
        arr[j+i*cols] = matrix[i][j];
      }
    }
    return arr;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //for ix1 matrixes adds one to the bottom
  Matrix addBias() {
    Matrix n = new Matrix(rows+1, 1);
    for (int i =0; i<rows; i++) {
      n.matrix[i][0] = matrix[i][0];
    }
    n.matrix[rows][0] = 1;
    return n;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //applies the activation function(sigmoid) to each element of the matrix
  Matrix activate() {
    Matrix n = new Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = sigmoid(matrix[i][j]);
      }
    }
    return n;
  }
  
//---------------------------------------------------------------------------------------------------------------------------------------------------------    
  //sigmoid activation function
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, -x));
    return y;
  }
  Matrix sigmoidDerived() {
    Matrix n = new Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = (matrix[i][j] * (1- matrix[i][j]));
      }
    }
    return n;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  Matrix removeBottomLayer() {
    Matrix n = new Matrix(rows-1, cols);      
    for (int i =0; i<n.rows; i++) {
      for (int j = 0; j<cols; j++) {
        n.matrix[i][j] = matrix[i][j];
      }
    }
    return n;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  
  void mutate(float mutationRate) {
    
    //pour chaque element du matrice
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        float rand = random(1);
        if (rand<mutationRate) {
          matrix[i][j] += randomGaussian()/5;//ajouter une valeur aleatoire
          
          //set the boundaries to 1 and -1
          if (matrix[i][j]>1) {
            matrix[i][j] = 1;
          }
          if (matrix[i][j] <-1) {
            matrix[i][j] = -1;
          }
        }
      }
    }
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  Matrix crossover(Matrix partner) {
    Matrix child = new Matrix(rows, cols);
    
    //choisir une point aleatoire du matrice
    int randC = floor(random(cols));
    int randR = floor(random(rows));
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {

        if ((i< randR)|| (i==randR && j<=randC)) { //si avant la point aleatoire donc copier de la matrice 
          child.matrix[i][j] = matrix[i][j];
        } else { //si apres la point aleatoire donc copier de le parametre array
          child.matrix[i][j] = partner.matrix[i][j];
        }
      }
    }
    return child;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  //retourner une copie de matrice
  Matrix clone() {
    Matrix clone = new  Matrix(rows, cols);
    for (int i =0; i<rows; i++) {
      for (int j = 0; j<cols; j++) {
        clone.matrix[i][j] = matrix[i][j];
      }
    }
    return clone;
  }
}
