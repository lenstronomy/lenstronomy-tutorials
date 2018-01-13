#!/usr/bin/env python

import os
import sys

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup


if sys.argv[-1] == 'publish':
    os.system('python setup.py sdist upload')
    sys.exit()

readme = open('README.rst').read()
doclink = """
Documentation
-------------

The full documentation is at http://lenstronomy_extensions.rtfd.org."""
history = open('HISTORY.rst').read().replace('.. :changelog:', '')

setup(
    name='lenstronomy_extensions',
    version='0.0.1',
    description='Deploys lenstronomy applications, examples and analysis scripts for lens modelling',
    long_description=readme + '\n\n' + doclink + '\n\n' + history,
    author='Simon Birrer',
    author_email='sibirrer@gmail.com',
    url='https://github.com/sibirrer/lenstronomy_extensions',
    packages=[
        'lenstronomy_extensions',
    ],
    package_dir={'lenstronomy_extensions': 'lenstronomy_extensions'},
    include_package_data=True,
    install_requires=[
    ],
    license='MIT',
    zip_safe=False,
    keywords='lenstronomy_extensions',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        'Natural Language :: English',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: Implementation :: PyPy',
    ],
)
