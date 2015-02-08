#!/usr/bin/env python2
# coding=utf-8
""" config for setuptools/stdeb """

from setuptools import setup
from luckyLUKS import VERSION_STRING

long_desc = """luckyLUKS is a Linux GUI for creating and (un-)locking
encrypted volumes from container files. Unlocked containers leave
an icon in the systray as a reminder to close them eventually ;)
Supports cryptsetup/LUKS and Truecrypt container files.

An encrypted container is basically a large file that encapsulates
an encrypted partition, which simplifies handling and backup of the
encrypted data - just copy the container file.
luckyLUKS follows a keep-it-simple philosophy for creating and using
encrypted containers, that aims to keep users from shooting themselves
in the foot. For quick access the GUI offers to add a shortcut
for unlocking a specific container to the start menu or on the desktop.

For more information and a complete FAQ see
https://github.com/jas-per/luckyLUKS
"""


setup(name='luckyLUKS',
      version=VERSION_STRING,
      author='Jasper van Hoorn',
      author_email='muzius@gmail.com',
      url='https://github.com/jas-per/luckyLUKS',
      download_url='https://github.com/jas-per/luckyLUKS',
      description='GUI for LUKS or TrueCrypt volumes from container files',
      long_description=long_desc,
      platforms=['Linux'],
      packages=['luckyLUKS'],
      package_data={'luckyLUKS': ['locale/*/LC_MESSAGES/*']},
      scripts=['lucky-luks'],
      keywords='python tools utils cryptsetup LUKS TrueCrypt encryption container block device mapper GUI tcplay',
      license='GPL',
      classifiers=['Development Status :: 5 - Production/Stable',
                   'Environment :: X11 Applications :: Qt',
                   'Intended Audience :: End Users/Desktop',
                   'Natural Language :: English',
                   'Natural Language :: German',
                   'Operating System :: POSIX :: Linux',
                   'Programming Language :: Python :: 2.7',
                   'Programming Language :: Python :: 3',
                   'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
                   'Topic :: Utilities',
                   'Topic :: Security :: Cryptography',
                   ],
      # setup_requires=['setuptools', 'stdeb', 'babel'],  # build failure on ppa
      install_requires=['setuptools'],
      )