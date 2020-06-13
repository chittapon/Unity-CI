using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;

public class BuildScript
{

    public static string IOS_FOLDER = "./Builds/iOS/";

    static string[] GetScenes () {
            List<string> scenes = new List<string> ();
            for (int i = 0; i < EditorBuildSettings.scenes.Length; i++) {
                if (EditorBuildSettings.scenes[i].enabled) {
                    scenes.Add (EditorBuildSettings.scenes[i].path);
                }
            }
            return scenes.ToArray ();
    }

    static void iOSDevelopment () {
            PlayerSettings.SetScriptingBackend (BuildTargetGroup.iOS, ScriptingImplementation.IL2CPP);
            PlayerSettings.applicationIdentifier = "com.pap.unityci";
            PlayerSettings.SetScriptingDefineSymbolsForGroup (BuildTargetGroup.iOS, "DEV");
            EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.iOS, BuildTarget.iOS);
            EditorUserBuildSettings.development = true;
            BuildReport report = BuildPipeline.BuildPlayer (GetScenes(), IOS_FOLDER, BuildTarget.iOS, BuildOptions.None);
            int code = (report.summary.result == BuildResult.Succeeded) ? 0 : 1;
            EditorApplication.Exit (code);    
    }

    static void iOSRelease () {
            PlayerSettings.SetScriptingBackend (BuildTargetGroup.iOS, ScriptingImplementation.IL2CPP);
            PlayerSettings.applicationIdentifier = "com.pap.unityci";
            PlayerSettings.SetScriptingDefineSymbolsForGroup (BuildTargetGroup.iOS, null);
            EditorUserBuildSettings.SwitchActiveBuildTarget (BuildTargetGroup.iOS, BuildTarget.iOS);
            BuildReport report = BuildPipeline.BuildPlayer (GetScenes(), IOS_FOLDER, BuildTarget.iOS, BuildOptions.None);
            int code = (report.summary.result == BuildResult.Succeeded) ? 0 : 1;
            EditorApplication.Exit (code);    
    }
}
