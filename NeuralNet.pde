class NeuralNet {

  int iNodes;  int hNodes;
  int oNodes;

  Matrix whi;
  Matrix whh;
  Matrix woh;
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  //constructor
  NeuralNet(int inputs, int hiddenNo, int outputNo) {

    //set dimensions from parameters
    iNodes = inputs;
    oNodes = outputNo;
    hNodes = hiddenNo;


  
    whi = new Matrix(hNodes, iNodes +1);

  
    whh = new Matrix(hNodes, hNodes +1);


    woh = new Matrix(oNodes, hNodes +1);  

   
    whi.randomize();
    whh.randomize();
    woh.randomize();
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

 
  void mutate(float mr) {

    whi.mutate(mr);
    whh.mutate(mr);
    woh.mutate(mr);
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  
  float[] output(float[] inputsArr) {

    //convertir le tableau vers matrice
    
    Matrix inputs = woh.singleColumnMatrixFromArray(inputsArr);

    //ajouter bias 
    Matrix inputsBias = inputs.addBias();




   
    Matrix hiddenInputs = whi.dot(inputsBias);

 
    Matrix hiddenOutputs = hiddenInputs.activate();

  
    Matrix hiddenOutputsBias = hiddenOutputs.addBias();

  
    Matrix hiddenInputs2 = whh.dot(hiddenOutputsBias);
    Matrix hiddenOutputs2 = hiddenInputs2.activate();
    Matrix hiddenOutputsBias2 = hiddenOutputs2.addBias();


    Matrix outputInputs = woh.dot(hiddenOutputsBias2);
 
    Matrix outputs = outputInputs.activate();


    return outputs.toArray();
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  NeuralNet crossover(NeuralNet partner) {

   
    NeuralNet child = new NeuralNet(iNodes, hNodes, oNodes);
    child.whi = whi.crossover(partner.whi);
    child.whh = whh.crossover(partner.whh);
    child.woh = woh.crossover(partner.woh);
    return child;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  NeuralNet clone() {
    NeuralNet clone  = new NeuralNet(iNodes, hNodes, oNodes); 
    clone.whi = whi.clone();
    clone.whh = whh.clone();
    clone.woh = woh.clone();

    return clone;
  }
//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  Table NetToTable() {

    //creer table
    Table t = new Table();


    //convertir matrice verss tablea
    float[] whiArr = whi.toArray();
    float[] whhArr = whh.toArray();
    float[] wohArr = woh.toArray();

    //initialiser les colonnes
    for (int i = 0; i< max(whiArr.length, whhArr.length, wohArr.length); i++) {
      t.addColumn();
    }

  
    TableRow tr = t.addRow();

    for (int i = 0; i< whiArr.length; i++) {
      tr.setFloat(i, whiArr[i]);
    }


   
    tr = t.addRow();

    for (int i = 0; i< whhArr.length; i++) {
      tr.setFloat(i, whhArr[i]);
    }


    tr = t.addRow();

    for (int i = 0; i< wohArr.length; i++) {
      tr.setFloat(i, wohArr[i]);
    }

    //retourner table
    return t;
  }

//---------------------------------------------------------------------------------------------------------------------------------------------------------  

  void TableToNet(Table t) {

    //creer un tableau pour restore des donnes des matrices
    float[] whiArr = new float[whi.rows * whi.cols];
    float[] whhArr = new float[whh.rows * whh.cols];
    float[] wohArr = new float[woh.rows * woh.cols];

   
    TableRow tr = t.getRow(0);

    for (int i = 0; i< whiArr.length; i++) {
      whiArr[i] = tr.getFloat(i);
    }



    tr = t.getRow(1);

    for (int i = 0; i< whhArr.length; i++) {
      whhArr[i] = tr.getFloat(i);
    }

    
    tr = t.getRow(2);

    for (int i = 0; i< wohArr.length; i++) {
      wohArr[i] = tr.getFloat(i);
    }



    whi.fromArray(whiArr);
    whh.fromArray(whhArr);
    woh.fromArray(wohArr);
  }
}
