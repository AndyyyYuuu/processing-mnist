public static String[] fetchBash(String[] command){
  Process process;
  try{
    process = exec(command);
  } catch (RuntimeException e){
    e.printStackTrace();
    return null;
  }
  
  try{
    process.waitFor();
  } catch (InterruptedException e){
    e.printStackTrace();
    return null;
  }
  
  BufferedReader reader = createReader(process.getInputStream());
  
  try {
    ArrayList<String> lines = new ArrayList<>();
    String line;
    while ((line = reader.readLine()) != null) {
      lines.add(line);
    }
    String[] linesArray = lines.toArray(new String[0]);
    return linesArray;
  } catch (IOException e) {
    e.printStackTrace();
    return null;
  }
}

private void printProcessOutput(Process process, String commandDescription) {
  println(commandDescription + " Output:");
  try {
    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    String line;
    while ((line = reader.readLine()) != null) {
      println(line);
    }
    process.waitFor();
  } catch (Exception e) {
    e.printStackTrace();
  }
}
