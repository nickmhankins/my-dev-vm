import os, argparse, datetime, hashlib, json

def parse_args():
  parser = argparse.ArgumentParser(description='do things')
  parser.add_argument('--box_path', help='Path to the Vagrant .box file')
  parser.add_argument('--build_version', help='Build version string')                 
  parser.add_argument('--metadata', '-m', default='build/metadata.json')
  parser.add_argument('--box_name', default='dev_vm')

  return parser.parse_args()

def read_json(file):
    try:
      print('Reading from file {}'.format(file))
      with open(file, 'r') as f:
        return json.load(f)
    except:
        print('Error reading file {}'.format(file))

def write_json_config(dict, path):
  s = json.dumps(dict, indent=2)
  with open(path, 'w') as f:
        f.write(s)

def get_md5(boxpath):
  hash_md5 = hashlib.md5()
  print('Generating MD5 for {}'.format(boxpath))
  with open(boxpath, 'rb') as f:
    for chunk in iter(lambda: f.read(4096), b""):
      hash_md5.update(chunk)
  return hash_md5.hexdigest()

def generate_new_version(build_version, boxpath):
  hash = get_md5(boxpath)
  return {
      'version': build_version,
      'providers': [
          {
            "name": "virtualbox",
            "url": "file://{}".format(boxpath),
            "checksum_type": "md5",
            "checksum": hash
          }
        ]
      }

def append_new_version(metadata, boxname, existinglist=None):
  base_dict = {
      "name": "{}".format(boxname),
      "versions": []
  }
  
  base_dict['versions'].append(metadata)
  if existinglist:
    for item in existinglist:
      base_dict['versions'].append(item)
  return base_dict

def rewrite_metadata_file(new_metadata, boxname, metadata_path):
  if os.path.exists(metadata_path):
    metadata = read_json(metadata_path)
    version_list = metadata['versions']
    config = append_new_version(new_metadata, boxname, version_list)
  else:
    config = append_new_version(new_metadata)
  write_json_config(config, metadata_path)

args = parse_args()
new_metadata = generate_new_version(args.build_version, args.box_path)
rewrite_metadata_file(new_metadata, args.box_name, args.metadata)
