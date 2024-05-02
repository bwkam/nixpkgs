{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-index-llms-ollama";
  version = "0.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_index_llms_ollama";
    inherit version;
    hash = "sha256-x5ZlS3PRA/kyTtTFXHbEm3NzirxuUNAllu1eKxxm3sU=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
  ];

  # Tests are only available in the mono repo
  doCheck = false;

  pythonImportsCheck = [
    "llama_index.llms.ollama"
  ];

  meta = with lib; {
    description = "LlamaIndex LLMS Integration for ollama";
    homepage = "https://github.com/run-llama/llama_index/tree/main/llama-index-integrations/llms/llama-index-llms-ollama";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
