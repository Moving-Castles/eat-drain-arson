import seqPreprocessor from "svelte-sequential-preprocessor";
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";
import { preprocessThrelte } from "@threlte/preprocess";

const config = {
  preprocess: seqPreprocessor([vitePreprocess(), preprocessThrelte()]),
};

export default config;
