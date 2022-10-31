# Remote-Copy
**Remote-Copy** (`remote_copy.sh`) is a [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) script to remotely copy file(s)/folder(s) using the secure remote copy ([scp](http://man7.org/linux/man-pages/man1/scp.1.html)) command, or the less-secure [sshpass](http://linux.die.net/man/1/sshpass) command when the localhost user is not certificate-authenticated on the remote server.

`run_remote_copy.sh` is a related wrapper script intended to be used for making unattended script calls into `remote_copy.sh` (*e.g.*, running cron jobs).

> Note that **Remote-Copy** is a backward-compatible upgrade of the [**Remote-Folder-Copy**](https://github.com/richbl/remote-folder-copy) project. In general, you will be better served using this project, as [**Remote-Folder-Copy**](https://github.com/richbl/remote-folder-copy) will likely no longer be maintained in favor of this project.

## [<img src="https://cloud.githubusercontent.com/assets/10182110/18208786/ae5d76b2-70e5-11e6-9663-cfe47d13f4d9.png" width="150" />](https://github.com/richbl/a-bash-template)Developed with a Bash Template (BaT)

**Remote-Copy** uses a bash template (BaT) called **[A-Bash-Template](https://github.com/richbl/a-bash-template)** designed to make script development and command line argument management more robust, easier to implement, and easier to maintain. Here are a few of those features:

- Dependencies checker: a routine that checks all external program dependencies (*e.g.*, [sshpass](http://linux.die.net/man/1/sshpass) and [jq](https://stedolan.github.io/jq/))
- Arguments and script details--such as script description and syntax--are stored in the [JSON](http://www.json.org/) file format (*i.e.*, `config.json`)
- JSON queries (using [jq](https://stedolan.github.io/jq/)) handled through wrapper functions
- A script banner function automates banner generation, reading directly from `config.json`
- Command line arguments are parsed and tested for completeness using both short and long-format argument syntax (*e.g.*, `-u|--username`)
- Optional command line arguments are permissible and managed through the JSON configuration file
- Template functions organized into libraries to minimize code footprint in the main script

For more details about using a bash template, [check out the BaT sources here](https://github.com/richbl/a-bash-template).

## Requirements

 - An operational [bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29) environment (bash 4.3.46 used during development)
 -  Two additional external programs:
    + [sshpass](http://linux.die.net/man/1/sshpass), for piping password into the [scp](http://man7.org/linux/man-pages/man1/scp.1.html) command when [scp](http://man7.org/linux/man-pages/man1/scp.1.html) cannot be used directly (*e.g.*, localhost user is not certificate-authenticated on the remote server)
    + [jq](https://stedolan.github.io/jq/), for parsing the `config.json` file

While this package was written and tested under Linux (Ubuntu 16.10), there should be no reason why this won't work under other Unix-like operating systems.


## Basic Usage
**Remote-Copy** is run through a command line interface, so all of the command options are made available there.

Here's the default response when running `remote_copy.sh` with no arguments:

      $ ./remote_copy.sh

       |
       | A bash script to remotely copy file(s)/folder(s) using scp
       |   0.7.1
       |
       | Usage:
       |   remote_copy -u username [-p password] -w website [-P port] -s source(s) -d destination
       |
       |   -u, --username 		username (must have local/remote permissions)
       |   -p, --password 		password used to access remote server (optional)
       |   -w, --website 		website domain name (e.g., example.com)
       |   -P, --port 			website/server SSH port
       |   -s, --source 		source file(s)/folder(s) path (quote mult. sources, "/path/file1 /path/folder2")
       |   -d, --destination 	destination folder path
       |

      Error: username argument (-u|--username) missing.
      Error: website argument (-w|--website) missing.
      Error: source argument (-s|--source) missing.
      Error: destination argument (-d|--destination) missing.


In this example, the program responds by indicating that the required script arguments must be set before proper operation.

When arguments are correctly passed, the script provides feedback on the success or failure of the remote folder copy:

    $ ./remote_copy.sh -u user -p 'pass123' -w example.com -s /home/user/src -d /home/user/desktop

       |
       | A bash script to remotely copy file(s)/folder(s) using scp
       |   0.7.1
       |
       | Usage:
       |   remote_copy -u username [-p password] -w website [-P port] -s source(s) -d destination
       |
       |   -u, --username 		username (must have local/remote permissions)
       |   -p, --password 		password used to access remote server (optional)
       |   -w, --website 		website domain name (e.g., example.com)
       |   -P, --port 			website/server SSH port
       |   -s, --source 		source file(s)/folder(s) path (quote mult. sources, "/path/file1 /path/folder2")
       |   -d, --destination 	destination folder path
       |

    Copying remote file(s)/folder(s) using scp...

    Success.
    Remote file(s)/folder(s) example.com:/home/user/src copied to /home/user/desktop/src.

### Copying Multiple Files/Folders
**Remote-Copy** (`remote_copy.sh`) permits for the remote copy of any number of files and/or folders to be copied from a remote server. It does this by taking advantage of the [scp](http://man7.org/linux/man-pages/man1/scp.1.html) command syntax defining a source object. In that syntax, multiple source objects (either files or folders) are identified individually using the space character (` `) to delimit each element. **Remote-Copy** (`remote_copy.sh`) uses that same syntax, but requires the `--s, --source(s)` script argument to be wrapped in quotation marks. (`"`). Quotation marks are _optional_ if only one source element is passed in.

For example, in the command sequence below, both a file and a folder are identified as source objects to be remotely copied:

    $ ./remote_copy.sh -u user -p 'pass123' -w example.com -s "/remote/user/srcfile /remote/user/another_location/srcfolder" -d /home/user/desktop

This syntax is slightly different if only one source element is passed on the command line:


    $ ./remote_copy.sh -u user -p 'pass123' -w example.com -s "/remote/user/srcfile" -d /home/user/desktop

As noted, when passing in only one source element, the quotation marks are *optional*:

    $ ./remote_copy.sh -u user -p 'pass123' -w example.com -s /remote/user/srcfile -d /home/user/desktop

This optional syntax provides a level of backward compatibility with this project's predecessor, the [**Remote-Folder-Copy**](https://github.com/richbl/remote-folder-copy) project.


### Choosing Between the `scp` and `sshpass` Commands

**Remote-Copy** (`remote_copy.sh`) uses two methods for copying folders from a remote server: [scp](http://man7.org/linux/man-pages/man1/scp.1.html) and [sshpass](http://linux.die.net/man/1/sshpass). The decision on which command to use is based on whether the `-p, --password` argument has been passed into the script. If no password is used, then the [scp](http://man7.org/linux/man-pages/man1/scp.1.html) command is used directly. If a password is passed into the script, then the [sshpass](http://linux.die.net/man/1/sshpass) command is used instead.

In general, it's preferred to use [scp](http://man7.org/linux/man-pages/man1/scp.1.html) with a current [certificate of authority](https://www.ssh.com/manuals/server-admin/44/Server_Authentication_with_Certificates.html) in place on the remote server. For the security-minded, users of this script should review the section entitled *Security Considerations* on the [sshpass](http://linux.die.net/man/1/sshpass) website.

## <img src="https://user-images.githubusercontent.com/10182110/198916805-2c139481-8d92-4484-b92e-1d440df68045.jpg" width="150" /> IMPORTANT: This Project Uses Git Submodules

This project uses a Git [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) project, specifically the `bash-lib` folder to keep this project up-to-date without manual intervention.

So, be sure to clone this project with the `--recursive` switch (`git clone --recursive https://github.com/this_project`) so any submodule project(s) will be automatically cloned as well. If you clone into this project without this switch, you'll likely see empty submodule project folders (depending on your version of Git).
