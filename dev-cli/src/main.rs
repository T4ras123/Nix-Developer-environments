use std::collections::HashMap;
use std::env;
use std::path::PathBuf;
use std::process::exit;

use std::ffi::CString;

use libc;

fn main() {
    let args: Vec<String> = env::args().collect();

    if args.len() < 2 || args.len() > 4 {
        eprintln!("Usage: dev [environment] [--repo /path/to/repo]");
        eprintln!("Available environments:");
        for key in get_environments_with_repo(&get_repo_root()).keys() {
            eprintln!("  - {}", key);
        }
        exit(1);
    }

    let env_name = args[1].to_lowercase();
    let repo_path = if args.len() == 4 {
        if args[2] == "--repo" {
            PathBuf::from(&args[3])
        } else {
            eprintln!("Unknown option: {}", args[2]);
            exit(1);
        }
    } else {
        get_repo_root()
    };

    let environments = get_environments_with_repo(&repo_path);

    let env_path = match environments.get(env_name.as_str()) {
        Some(path) => path.clone(),
        None => {
            eprintln!("Unknown environment: {}", env_name);
            eprintln!("Available environments:");
            for key in environments.keys() {
                eprintln!("  - {}", key);
            }
            exit(1);
        }
    };

    if !env_path.exists() {
        eprintln!("Environment directory does not exist: {}", env_path.display());
        exit(1);
    }

    if let Err(e) = env::set_current_dir(&env_path) {
        eprintln!("Failed to change directory to {}: {}", env_path.display(), e);
        exit(1);
    }

    let nix_command = "nix";
    let nix_args = ["develop"];

    // Convert command and arguments to CStrings
    let nix_c = match CString::new(nix_command) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Failed to convert command to CString: {}", e);
            exit(1);
        }
    };

    let args_c: Vec<CString> = nix_args
        .iter()
        .map(|arg| {
            CString::new(*arg).unwrap_or_else(|_| {
                eprintln!("Failed to convert argument to CString");
                exit(1);
            })
        })
        .collect();

    let mut exec_args: Vec<*const libc::c_char> = Vec::with_capacity(args_c.len() + 2);
    exec_args.push(nix_c.as_ptr());
    for arg in &args_c {
        exec_args.push(arg.as_ptr());
    }
    exec_args.push(std::ptr::null());

    unsafe {
        libc::execvp(nix_c.as_ptr(), exec_args.as_ptr());
    }

    eprintln!("Failed to execute 'nix develop'");
    exit(1);
}

fn get_environments_with_repo(repo_root: &PathBuf) -> HashMap<&'static str, PathBuf> {
    let mut environments = HashMap::new();
    environments.insert("go", repo_root.join("Go_dev_env"));
    environments.insert("java", repo_root.join("Java_dev_env"));
    environments.insert("javascript", repo_root.join("JS_dev_env"));
    environments.insert("js", repo_root.join("JS_dev_env"));
    environments.insert("haskell", repo_root.join("Haskell_dev_env"));
    environments.insert("c", repo_root.join("C_dev_env"));
    environments.insert("cpp", repo_root.join("C_dev_env"));
    environments.insert("rust", repo_root.join("Rust_dev_env"));
    environments.insert("zig", repo_root.join("Zig_dev_env"));
    environments.insert("ml", repo_root.join("ML_dev_env"));
    environments.insert("python", repo_root.join("ML_dev_env"));
    environments
}

fn get_repo_root() -> PathBuf {
    if let Ok(repo) = env::var("DEV_REPO_PATH") {
        let path = PathBuf::from(repo);
        if path.join(".git").exists() {
            return path;
        } else {
            eprintln!(
                "The path specified in DEV_REPO_PATH does not contain a .git directory."
            );
            exit(1);
        }
    }

    let mut dir = env::current_dir().expect("Failed to get current directory");
    loop {
        if dir.join(".git").exists() {
            return dir;
        }
        if !dir.pop() {
            eprintln!("Could not find the repository root.");
            exit(1);
        }
    }
}