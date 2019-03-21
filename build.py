# Workflow:
#   Purpose is for rebuilding a Vagrant box using Packer, incrementing the version, adding to the metadata.json, and adding to your list of boxes
#   If it does not find a metadata.json, it will create one
#   Packer needs to run first, then output the box, then the script will add the metadata details to the json file, or create if it doesn't exist 
import os, argparse, datetime, hashlib, json

parser = argparse.ArgumentParser(description='do things')
parser.add_argument('jsonfile', help='Path to the packer JSON file')
parser.add_argument('builder', help='virtualbox or hyperv')                 
parser.add_argument('--boxname', '-b', default='dev_vm')
parser.add_argument('--vagrantadd', '-va', 
                    help='Runs vagrant box add on the generated metadata',
                    action="store_true")

args = parser.parse_args()

def execute(system_command):
    try:
        os.system(system_command)
    except Exception as e:
        print(e)

def run_packer(packerfile, version, boxname):
  if args.builder == 'virtualbox':
    builder = 'virtualbox-iso'
  else:
    builder = 'hyperv-iso'
  execute("packer build -only={} -var 'build_version={}' -var 'box_name={}' {}".format(builder, version, boxname, packerfile))

def read_json(file):
    try:
      print('Reading from file {}'.format(file))
      with open(file, 'r') as f:
        return json.load(f)
    except:
        print('Error reading file {}'.format(file))

def write_json_config(dict):
  s = json.dumps(dict, indent=2)
  with open(metadata_path, 'w') as f:
        f.write(s)

def get_md5(boxpath):
  hash_md5 = hashlib.md5()
  print('Generating MD5 for {}'.format(boxpath))
  with open(boxpath, 'rb') as f:
    for chunk in iter(lambda: f.read(4096), b""):
      hash_md5.update(chunk)
  return hash_md5.hexdigest()

def generate_new_version(version, builder, boxpath):
  hash = get_md5(boxpath)
  return {
      'version': version,
      'providers': [
          {
            "name": builder,
            "url": "file://{}".format(boxpath),
            "checksum_type": "md5",
            "checksum": hash
          }
        ]
      }

def append_new_version(metadata, existinglist=None):
  base_dict = {
      "name": "{}".format(args.boxname),
      "versions": []
  }
  if existinglist:
    base_dict['versions'].append(metadata)
    for item in existinglist:
      base_dict['versions'].append(item)
  else:
    base_dict['versions'].append(metadata)
  return base_dict

def rewrite_metadata_file(new_metadata):
  if os.path.exists(metadata_path):
    metadata = read_json(metadata_path)
    version_list = metadata['versions']
    config = append_new_version(new_metadata, version_list)
  else:
    config = append_new_version(new_metadata)
  write_json_config(config)

def vagrant_box_add():
  if args.vagrantadd:
    execute('vagrant box add {}'.format(metadata_path))

boxname_prefix = 'centos75-packer'
build_num = datetime.datetime.now().strftime("%Y%m%d.%H%M%S")
relative_box_path = 'build/{}/{}-{}.box'.format(args.builder, boxname_prefix, build_num)
abs_box_path = os.path.abspath(relative_box_path)

run_packer(args.jsonfile, build_num, boxname_prefix)
metadata_path = 'build/metadata.json'
new_metadata = generate_new_version(build_num, args.builder, abs_box_path)
rewrite_metadata_file(new_metadata)
vagrant_box_add()
