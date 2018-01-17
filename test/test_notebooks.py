import os
import subprocess
import tempfile
import pytest
import nbformat

dir = os.path.dirname(__file__)
path_list = os.path.split(dir)
extension_path = path_list[0]
notebook_path = os.path.join(extension_path, 'lenstronomy_extensions/Notebooks')


def _notebook_run(path):
    """Execute a notebook via nbconvert and collect output.
       :returns (parsed nb object, execution errors)
    """
    #dirname, __ = os.path.split(path)
    os.chdir(notebook_path)
    print(notebook_path)
    with tempfile.NamedTemporaryFile(suffix=".ipynb") as fout:
        args = ["nbconvert", "--to", "notebook", "--execute",
          "--ExecutePreprocessor.timeout=60",
          "--output", fout.name, path]
        subprocess.check_call(args)

        fout.seek(0)
        nb = nbformat.read(fout, nbformat.current_nbformat)

    errors = [output for cell in nb.cells if "outputs" in cell
                     for output in cell["outputs"]\
                     if output.output_type == "error"]

    return nb, errors


def test_ipynb_cosmic_shear_Einstein_rings():

    path = 'EinsteinRingShear_simulations.ipynb'
    nb, errors = _notebook_run(path)
    assert errors == []



if __name__ == '__main__':
    pytest.main()
